`timescale 1ns / 1ps

module VGA_Top_Module(input clk, 
							 input sw,
							 input btnl,
							 input btnr,
							 input [15:0] data,
							 output hsync, 
							 output vsync, 
							 output [7:0] RGB,
							 output [14:0] addr);
	 
wire [9:0] horizontal_pixel_counter;
wire [8:0] vertical_line_counter;
wire request;
wire [1:0] mode;
wire [7:0] Next_RGB;

VGA_Signal_Generator _VGA_Signal_Generator(clk, sw, btnl, btnr, hsync, vsync, request, horizontal_pixel_counter, vertical_line_counter, mode, Next_RGB, RGB);

VGA_Pixel_Generator _VGA_Pixel_Generator(clk, request, mode, horizontal_pixel_counter, vertical_line_counter, Next_RGB, data, addr);

endmodule
