`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Utah
// Engineer: Logan M. Ropelato
// 
// Create Date:    17:49:32 09/03/2017 
// Design Name: 
// Module Name:    VGA_Pixel_Generator 
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
//                                                                                                                                                                 jjj               j        3
//////////////////////////////////////////////////////////////////////////////////
module VGA_Signal_Generator(input clk, 
									 input sw,
									 input btnl,
									 input btnr,
									 output reg hsync, 
									 output reg vsync, 
									 output reg request, 
									 output reg [9:0] hcount, 
									 output reg [8:0] vcount,								 
									 output reg [1:0] mode,
									 input [7:0] Next_RGB,
									 output reg [7:0] RGB);
	 
reg [1:0] pixel_rate = 0;
wire pixel_ending;

reg [9:0] horizontal_pixel_counter;
reg [9:0] vertical_line_counter;

initial hsync = 1;
initial vsync = 1;

initial horizontal_pixel_counter = 0;
initial vertical_line_counter = 0;
initial hcount = 0;
initial vcount = 0;
initial RGB = 0;

//Every time the pixel rate is 3, enable signal is high
assign pixel_ending = pixel_rate == 3;

always@(posedge clk)
	begin
		//Alter clock to be 25 Mhz instead of 100 Mhz
		if(pixel_rate == 3)
			begin
			pixel_rate <= 0;
			request <= 1;
			end
		else
			begin
			pixel_rate <= pixel_rate + 2'b1;
			request <= 0;
			end

		//Horizontal Counter	
		//When to reset?
		
		if (pixel_ending)
		begin
			hcount <= horizontal_pixel_counter - 9'd45;
			vcount <= vertical_line_counter[8:0] - 9'd33;
		end
		else
		begin
			hcount <= hcount;
			vcount <= vcount;
		end
		
		if ((horizontal_pixel_counter >= 47 && horizontal_pixel_counter < 687) && (vertical_line_counter >= 32 && vertical_line_counter <512))
			RGB <= Next_RGB;
		else
			RGB <= 8'b0;
		
		if (pixel_ending && (horizontal_pixel_counter == 799))
			horizontal_pixel_counter <= 0;
		else if (pixel_ending)
			horizontal_pixel_counter <= horizontal_pixel_counter + 10'b1;
		
		//When to turn on hsync?
		if (pixel_ending && (horizontal_pixel_counter >= 703 && horizontal_pixel_counter < 799))
			hsync <= 0;	
		else if (pixel_ending)
			hsync <= 1;
		
		//Vertical Counter	
		//When to reset?
		if ((pixel_ending && (horizontal_pixel_counter == 799)) && (vertical_line_counter == 525))
			vertical_line_counter <= 0;
		else if (pixel_ending && (horizontal_pixel_counter == 799))
			vertical_line_counter <= vertical_line_counter + 10'b1;
		
		//When to turn on vsync?
		if (pixel_ending && (vertical_line_counter >= 523 && vertical_line_counter < 525))
			vsync <= 0;
		else if (pixel_ending)
			vsync <= 1;
			
		//Mode toggling
		if (sw)
		mode <= 1;
		else if (btnl)
		mode <= 0;
		else if (btnr)
		mode <= 2;
		
	end
	
endmodule
