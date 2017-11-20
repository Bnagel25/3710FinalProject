`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Utah	
// Engineer: Logan Ropelato, Marko Ljubicic
// 
// Create Date:    16:35:42 11/18/2017 
// Design Name: 
// Module Name:    IO_Controller 
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
module IO_Controller(
	input            PS2KeyboardClk,
	input            PS2KeyboardData,
	output reg [7:0] led);

//Internal registers for holding data
	reg       IO_state;
	reg [2:0] idx;
	reg [3:0] bitCounter;
	reg [7:0] keyboardData;

	initial
	 begin
	  bitCounter = 0;    //bit counter for incoming data bits
	  idx = 0;           //keyboardData index
	  led = 1;           //led output
	  IO_state = IDLING; //initial state
	 end

//States
	parameter IDLING   = 0;
	parameter SAMPLING = 1;

//Sequential logic 
	always@(negedge PS2KeyboardClk)
	begin
	 case (IO_state)
	 //IDLING state waits for a key to be pressed
	  IDLING: begin
	           bitCounter <= bitCounter + 4'b1;
	           IO_state <= SAMPLING;
	          end
	 //SAMPLING state begins when the key is pressed and ends when a "f0" is returned
	  SAMPLING: begin 
	             if (bitCounter >= 1 && bitCounter <= 8)
	              begin
	               keyboardData[idx] <= PS2KeyboardData;
	               idx <= idx + 1'b1;
	              end

	             if (bitCounter == 4'b1010)
	              begin
	               if (keyboardData != 8'hf0)
	                led <= keyboardData;

	               IO_state <= IDLING;
	               bitCounter <= 0;
	               idx <= 0;
	               keyboardData <= 0;
	              end
	             else
	              bitCounter <= bitCounter + 1'b1;
	            end
	 endcase
	end

endmodule
