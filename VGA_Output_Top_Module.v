`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:26:53 09/12/2017 
// Design Name: 
// Module Name:    VGA_Output_Top_Module 
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
module VGA_Output_Top_Module(input clk,
	output hsync,
	output vsync,
	output [7:0] RGB
    );

	wire request;
	wire [9:0] displayColumnCount;
	wire [9:0] displayRowCount;
	wire [2:0] mode;
	wire [7:0] next_color;
	wire bright;

	Signal_Generator theSignalGenerator (clk, next_color, hsync, vsync, RGB, request, bright, displayColumnCount, displayRowCount, mode);
	
	Pixel_Generator thePixelGenerator(clk, request, displayColumnCount, displayRowCount, mode, next_color, bright);

endmodule
