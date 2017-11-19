`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Memory_Control(
	input      [07:0] IO_to_mem_data,
	input      [15:0] ram_to_mem_data,
	input      [15:0] core_to_mem_data,
	input      [23:0] core_to_mem_address,
	input             core_to_mem_write_enable,
	output            mem_to_ram_write_enable,
	output     [23:0] mem_to_ram_address,
	output     [15:0] mem_to_ram_data,
	//output reg [15:0] mem_to_IO_data,
	output reg [15:0] mem_to_core_data);

	reg [15:0] buffer_out;
	
	assign mem_to_ram_write_enable = core_to_mem_write_enable;
	assign mem_to_ram_address = core_to_mem_address;
	assign mem_to_ram_data = core_to_mem_data;
	
// Combinatorial
	always@*
	begin
	 if (core_to_mem_address != 24'h3b00)
	  mem_to_core_data = ram_to_mem_data;
	 else
	  mem_to_core_data = buffer_out;
	end

// Keyboard to address conversion
	always@*
	begin
	 case (IO_to_mem_data)
	  8'h1b : buffer_out = 16'hff53;
	  8'h1c : buffer_out = 16'hff41;
	  8'h1d : buffer_out = 16'hff57;
	  8'h23 : buffer_out = 16'hff44;
	  8'h75 : buffer_out = 16'hff2f;
	  8'h72 : buffer_out = 16'hff5c;
	 endcase
	end
	
endmodule
