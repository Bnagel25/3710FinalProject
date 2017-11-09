`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:47 11/05/2017 
// Design Name: 
// Module Name:    Top_Level_Core_Demo 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//synthesis attribute box_type Block_Ram "black_box"
module Top_Level_Core_Demo(
	input clk,
	input sw,
	input btnl,
	input btnr,
	output hsync,
	output vsync,
	output [7:0] RGB);

	wire [15:0] mem_to_core_data;          // instruction
	wire [23:0] core_to_mem_address;       // address of instruction
	wire [15:0] core_to_mem_data;          // data at address
	wire 			core_to_mem_write_enable;  // memory write enable
	
	Core _Core(
	.clk                      (clk),
	.mem_to_core_data         (mem_to_core_data),
	.core_to_mem_address      (core_to_mem_address),
	.core_to_mem_data         (core_to_mem_data),
	.core_to_mem_write_enable (core_to_mem_write_enable));

	wire [15:0] mem_to_vga_data;
	wire [14:0] vga_to_mem_addr;
	
	VGA_Top_Module _VGA_Top_Module(
	.clk   (clk), 
	.sw    (sw),
	.btnl  (btnl),
	.btnr  (btnr),
	.hsync (hsync), 
	.vsync (vsync), 
	.RGB   (RGB),
	.data  (mem_to_vga_data),
	.addr  (vga_to_mem_addr));
	
	Block_Ram _Block_Ram(
	// VGA port
	.clka  (clk),
	.wea   (1'b0),
	.addra (vga_to_mem_addr),
	.dina  (16'b0),
	.douta (mem_to_vga_data),
	// Core port
	.clkb  (clk),
	.web   (core_to_mem_write_enable),
	.addrb (core_to_mem_address[14:0]),
	.dinb  (core_to_mem_data),
	.doutb (mem_to_core_data));
	
endmodule
