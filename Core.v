`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Core(
	input             clk,
	input      [15:0] mem_to_core_data,          // instruction
	output reg [15:0] core_to_mem_data,          // data at address
	output reg [23:0] core_to_mem_address,       // address of instruction
	output reg        core_to_mem_write_enable); // memory write enable

	// Intructions
	parameter ADD  = 4'b0000;
	parameter ADDI = 4'b0001;
	parameter SUB  = 4'b0010;
	parameter LW   = 4'b0011;
	parameter SW   = 4'b0100;
	parameter LUI  = 4'b0101;
	parameter CMP  = 4'b0110;
	parameter BR   = 4'b0111;
	parameter JMP  = 4'b1000;
	parameter SLL  = 4'b1001;
	parameter SLR  = 4'b1010;
	parameter AND  = 4'b1011;
	parameter NAND = 4'b1100;
	parameter OR   = 4'b1101;
	parameter NOT  = 4'b1110;
	parameter LLI  = 4'b1111;
	
	// State
	parameter FETCH   = 3'b000;
	parameter DECODE  = 3'b001;
	parameter EXECUTE = 3'b010;
	parameter LOAD1   = 3'b011;
	parameter LOAD2   = 3'b100;
	parameter STORE   = 3'b101;
	parameter BRANCH  = 3'b110;
	parameter JUMP    = 3'b111;

	// Registers for core state that persists between instructions
	reg        zero;
	reg        negative;
	reg [2:0]  core_state = FETCH;
	reg [23:0] pc         = 24'h3c8c; // Start instructions at 15500
	
	// Registers for core states that persists between cycles w/in instruction
	reg [3:0]  opcode;
	reg [3:0]  offset;
	reg [3:0]  dest_index;
	reg [7:0]  immediate;
	reg [15:0] reg_data1;
	reg [15:0] reg_data2;
	reg [15:0] neg_temp;
	
	// Wires and registers to pass data
	reg         write_enable;
	reg  [3:0]  read_index1;
	reg  [3:0]  read_index2;
	reg  [3:0]  write_index;
	reg  [15:0] write_data;
	reg  [23:0] addr;
	wire [15:0] read_data1;
	wire [15:0] read_data2;
	
	
	reg_file _reg_file(
	 .clk      (clk), 
	 .rdDataA  (read_index1),
	 .rdDataB  (read_index2),
	 .write_en (write_enable),
	 .DataIn   (write_data),
	 .wrData   (write_index),
	 .A		  (read_data1),
	 .B		  (read_data2));
	
	
	//Combinatorial
	always@(*)
	begin
	 //Assign values to be 0, ensuring everything has a default value
	 read_index1  = 0;
	 read_index2  = 0;
	 write_data   = 0;
	 write_enable = 0;
	 write_index  = 0;
	
	 core_to_mem_address      = 0;
	 core_to_mem_data         = 0;
	 core_to_mem_write_enable = 0;
	
	 case (core_state)
	  FETCH:   core_to_mem_address = pc; 
	  DECODE:  begin 
				   read_index1 = mem_to_core_data[11:8]; //source
				   read_index2 = mem_to_core_data[7:4];  //dest

				   if (opcode == LW || opcode == SW || opcode == BR || opcode == JMP)
				    core_to_mem_address = pc;
			     end
	  EXECUTE: begin 
	            write_index  = dest_index;
				   write_enable = 1;
				   if      (opcode == ADD)
				    write_data = reg_data1 + reg_data2;
				   else if (opcode == ADDI)
				    write_data = reg_data1 + immediate;
				   else if (opcode == SUB)
				    write_data = reg_data2 - reg_data1;						 
				   else if (opcode == SLL)
				    write_data = reg_data1 << offset;
				   else if (opcode == SLR)
				    write_data = reg_data1 >> offset;
				   else if (opcode == AND)
				    write_data = reg_data1 & reg_data2;
				   else if (opcode == NAND)
				    write_data = ~(reg_data1 & reg_data2);
				   else if (opcode == OR)
				    write_data = reg_data1 | reg_data2;
				   else if (opcode == NOT)
				    write_data = ~reg_data1;
				   else if (opcode == LUI)
				    write_data = {immediate, reg_data1[7:0]};
				   else if (opcode == LLI)
				    write_data = {reg_data1[15:8], immediate};
				   else if (opcode == CMP)
				    write_enable = 0;
				  end
	  LOAD1:   core_to_mem_address  = {immediate, mem_to_core_data};
	  LOAD2:   begin
				   write_enable = 1;
				   write_index  = dest_index;
				   write_data   = core_to_mem_data;
				  end
	  STORE:   begin
				   core_to_mem_address      = {immediate, mem_to_core_data};
				   core_to_mem_data         = reg_data1;
				   core_to_mem_write_enable = 1;
				  end
	  BRANCH:  begin end
	  JUMP:    begin end
	 endcase
	end
	
	//Sequential
	always@(posedge clk)
	 begin	
	 case (core_state)
	  FETCH:   begin 
			      core_state <= DECODE;
			      pc <= pc + 1'b1;
			     end
	  DECODE:  begin
				   opcode      = mem_to_core_data[15:12];
				   immediate  <= mem_to_core_data[7:0];
				   offset     <= mem_to_core_data[3:0];
				   reg_data1  <= read_data1;
				   reg_data2  <= read_data2;
					
				   if (opcode == LUI || opcode == LLI || opcode == ADDI)
				    dest_index <= mem_to_core_data[11:8];
				   else
				    dest_index <= mem_to_core_data[7:4];
					 
				   if (opcode == ADD  ||
				       opcode == ADDI ||
				       opcode == SUB  ||
				       opcode == CMP  ||
				       opcode == SLL  ||
				       opcode == SLR  ||
				       opcode == AND  ||
				       opcode == NAND ||
				       opcode == OR   ||
				       opcode == LUI  ||
				       opcode == LLI  ||
				       opcode == NOT)
				    core_state <= EXECUTE;
				   else if (opcode == LW)
				    core_state <= LOAD1;
				   else if (opcode == SW)
				    core_state <= STORE;
				   else if (opcode == BR)
				    core_state <= BRANCH;
				   else if (opcode == JMP)
				    core_state <= JUMP;
				  end
	  EXECUTE: begin 
				   if (opcode == CMP) 
				   begin    
				    zero <= reg_data1 == reg_data2;
				    negative <= reg_data1 < reg_data2;	
				   end
				   core_state <= FETCH;
				  end
	  LOAD1:   core_state <= LOAD2;
	  LOAD2:   begin
	            pc <= pc + 1'b1;
	            core_state <= FETCH;
	           end
	  STORE:   begin
				   pc <= pc + 1'b1;
				   core_state <= FETCH;
				  end
	  BRANCH:  begin
	            pc <= pc + 1'b1;
               // read_index1 specifies the branch type in a BRANCH instruction--bits [11:8] in an instruction.	
				   if      (read_index1==4'b0000) // Branch on equal 
				    if (zero)
				     pc <= {immediate, mem_to_core_data};
				   else if (read_index1==4'b0001) // Branch on not equal
				    if (!zero)
				     pc <= {immediate, mem_to_core_data};	 			 
				   else if (read_index1==4'b0010) // Branch on less than
				    if (negative)
				     pc <= {immediate, mem_to_core_data};					 
				   else if (read_index1==4'b0011) // Branch on less than or equal to
				    if (zero || negative)
				     pc <= {immediate, mem_to_core_data};				 
				   else if (read_index1==4'b0100) // Branch on greater than
				    if (!negative && !zero)
				     pc <= {immediate, mem_to_core_data};
				   else
				    pc <= pc + 1'b1;
				   else if (read_index1==4'b0101) // Branch on greater than or equal to
				    if (!negative || zero)
				     pc <= {immediate, mem_to_core_data};
					  
				   core_state <= FETCH;					 
				  end
	  JUMP:    begin
			      pc <= {immediate, mem_to_core_data};
			      core_state <= FETCH;			  
				  end	
	  endcase
	 end
	 
endmodule
