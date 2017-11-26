`timescale 1ns / 1ps
module reg_file(
	input clk,
	input write_en,
	input [3:0] wrData,
	input [15:0] DataIn,
	input [3:0] rdDataA,
	input [3:0] rdDataB,
	output reg [15:0] A,
	output reg [15:0] B);

	reg [15:0] reg1,  reg2,  reg3,  reg4;
   reg [15:0] reg5,  reg6,  reg7,  reg8;
   reg [15:0] reg9,  reg10, reg11, reg12;
   reg [15:0] reg13, reg14, reg15;
	
	// Read from registers
	always@(*)
	begin
		case (rdDataA)
		 0 : A = 0;
		 1 : A = reg1;
		 2 : A = reg2;
		 3 : A = reg3;
		 4 : A = reg4;
		 5 : A = reg5;
		 6 : A = reg6;
		 7 : A = reg7;
		 8 : A = reg8;
		 9 : A = reg9;
		 10 : A = reg10;
		 11 : A = reg11;
		 12 : A = reg12;
		 13 : A = reg13;
		 14 : A = reg14;
		 15 : A = reg15;
		endcase
		
		case (rdDataB)
		 0 : B = 0;
		 1 : B = reg1;
		 2 : B = reg2;
		 3 : B = reg3;
		 4 : B = reg4;
		 5 : B = reg5;
		 6 : B = reg6;
		 7 : B = reg7;
		 8 : B = reg8;
		 9 : B = reg9;
		 10 : B = reg10;
		 11 : B = reg11;
		 12 : B = reg12;
		 13 : B = reg13;
		 14 : B = reg14;
		 15 : B = reg15;
		endcase	
	end
	
	// Write to registers
	always@(posedge clk)
	begin
	   if (write_en)
			case (wrData)
				0 : begin end
				1 : reg1 <= DataIn;
				2 : reg2 <= DataIn;
				3 : reg3 <= DataIn;
				4 : reg4 <= DataIn;
				5 : reg5 <= DataIn;
				6 : reg6 <= DataIn;
				7 : reg7 <= DataIn;
				8 : reg8 <= DataIn;
				9 : reg9 <= DataIn;
			  10 : reg10 <= DataIn;
			  11 : reg11 <= DataIn;
			  12 : reg12 <= DataIn;
			  13 : reg13 <= DataIn;
			  14 : reg14 <= DataIn;
			  15 : reg15 <= DataIn;
			endcase
	end

endmodule
