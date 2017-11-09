`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Utah
// Engineer: Logan M. Ropelato
// 
// Create Date:    14:21:17 09/14/2017 
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
//
//////////////////////////////////////////////////////////////////////////////////
module VGA_Pixel_Generator(input clk,
									input request,
									input [1:0] mode,
									input [9:0] hcount, 
									input [8:0] vcount, 
									output reg [7:0] Next_RGB,
									input [15:0] data,
									output reg [14:0] addr);
reg [30:0] seed;
initial seed = 1;
initial Next_RGB = 8'b0;

reg [1:0] state;
initial state = 0;

reg [2:0] current_row;
reg [2:0] current_column;

always@(posedge clk)
	begin
	
	//Prepare seed if the snow mode is chosen
	seed <= {seed[28:0], seed[30]^seed[27], seed[29]^seed[26]};
	
	//If the next pixel has been requested
	if (request)
	begin
			//Snow
			if (mode == 0)
				Next_RGB  <=  seed[7:0];	
				
			//Checkerboard
			else if (mode ==2)
				Next_RGB <= {3'b000, vcount[5] ^ hcount[5], 4'b0000};
				
			else
			begin
			//Latch current row and column values (LSB's)
			current_row <= vcount[2:0];
			current_column <= hcount[2:0];	
			end				
	end //end request
	
	//Glyphs
	//State 0
	//Advance from State 0 to State 1
	if (state == 0)
		if (mode == 1 && request)
		state <= 2'b01;
		else
		state <= 0;
	
	//State 1
	//Advance from State 1 to State 2
	else if (state == 1)				
		state <= 2'b10;
		
	//State 2
	//Extract bit, compute color
	else if (state == 2)
		begin
		//If we're in the bottom half of the word
		if (!current_row[0])
			begin
			if (data[current_column + 8])
			//WHITE
			Next_RGB <= 8'b11111111;
			else
			//BLACK
			Next_RGB <= 8'b00000000;
			end
			
		//If we're in the top half of the word
		else
			begin
			if(data[current_column])
			//WHITE
			Next_RGB <= 8'b11111111;
			else
			//BLACK
			Next_RGB <= 8'b00000000;
			end
		state <= 0;
		end//end state 2
	else
	//Reset to State 0
	state <= 0;
end//end always@(posedge clk)
	
//Combinatorial logic 
always@(*)
begin
	//State 0
	//Find character by computing mem addr. for that character and
	//delivering that addr to RAM
	if (state == 0)
		addr = {vcount[8:3], hcount[9:3]};

	//State 1
	//Got character, Compute mem addr for Glyph, deliver that addr to RAM
	else if (state == 1)
		addr = {4'b1000, data[7:0], current_row[2:1]};
		
	else
		addr = 8'b00000000;	
end //end always@(*)
endmodule
