`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:28 09/12/2017 
// Design Name: 
// Module Name:    Signal_Generator 
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
module Signal_Generator(input clk, 
								input [7:0] next_color, 
								output reg hsync, 
								output reg vsync, 
								output reg [7:0] RGB, 
								output reg request,
								output reg bright,
								output reg [9:0] displayColumnCount, 
								output reg [9:0] displayRowCount, 
								output reg [2:0] mode
								);

reg [1:0] pixel_rate = 0;
reg [9:0] horizontal_pixel_counter = 0;
reg [9:0] vertical_line_counter = 0;
wire enable_reg;

initial bright = 0;

initial hsync = 1;
initial vsync = 1;
initial mode = 0;
initial RGB = 8'b0;

//Every time the pixel rate is 3, enable signal is high
assign enable_reg = pixel_rate == 3;

//Color Changer
always@(*)
	begin
	
		//If we are within the draw-able area
		if ((horizontal_pixel_counter >= 47 && horizontal_pixel_counter < 687) && (vertical_line_counter >= 32 && vertical_line_counter <512))	
			 bright = 1;
		else
			bright = 0;
	end	

always@(posedge clk)
	begin
	
	
		//Alter clock to be 25 Mhz instead of 100 Mhz
		if(pixel_rate == 3)
			begin
			pixel_rate <= 0;
			request <= 1; //NEW FOR PIXEL GENERATOR
			RGB <= next_color;
			end
		else
			begin
			pixel_rate <= pixel_rate + 2'b1;
			request <= 0; //NEW FOR PIXEL GENERATOR
			end

		//Horizontal Counter	
		//When to reset?
		if (enable_reg && (horizontal_pixel_counter == 799))
			horizontal_pixel_counter <= 0;
		else if (enable_reg)
			horizontal_pixel_counter <= horizontal_pixel_counter + 10'b1;

		//When to turn on hsync?
		if (enable_reg && (horizontal_pixel_counter >= 703 && horizontal_pixel_counter < 799))
			hsync <= 0;	
		else if (enable_reg)
			hsync <= 1;
	
		if (bright)
			begin
			if (displayColumnCount == 639)
				 begin
				 displayColumnCount <= 0;
				 if (displayRowCount == 479)
					displayRowCount <= 0;
				 else
					displayRowCount <= displayRowCount + 10'b1;	
			   end
			else
				displayColumnCount <= displayColumnCount + 10'b1;	 
			end//End bright
			
		//Vertical Counter	
		//When to reset?
		if ((enable_reg && (horizontal_pixel_counter == 799)) && (vertical_line_counter == 525))
			vertical_line_counter <= 0;
		else if (enable_reg && (horizontal_pixel_counter == 799))
			vertical_line_counter <= vertical_line_counter + 10'b1;
		
		//When to turn on vsync?
		if (enable_reg && (vertical_line_counter >= 523 && vertical_line_counter < 525))
			vsync <= 0;
		else if (enable_reg)
			vsync <= 1;
	end

endmodule
