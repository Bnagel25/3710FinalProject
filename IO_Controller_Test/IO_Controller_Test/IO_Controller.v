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
//module IO_Controller(
//    input PS2KeyboardClk,
//    input PS2KeyboardData,
//    output reg [7:0] IO_to_memcon_data,
//	 output reg [7:0] led
//    );
//
//	//Internal registers for holding data
//	reg [7:0] keyboardData;
//	reg [3:0] bitCounter;
//	reg [1:0] IO_state;
//	reg [2:0] idx;
//	
//	
//	//bit counter for incoming data bits
//	initial bitCounter = 0;
//	initial idx = 0;
//	
//	//led output
//	initial led = 1;
//	
//	
//	//initial state
//	initial IO_state = IDLING;
//
//	//States
//	parameter IDLING   = 2'b00;
//	parameter SAMPLING = 2'b01;
//	
//	//Combinatorial logic
//	always@(*)
//	begin
//	
//	end
//
//	//Sequential logic 
//   always@(negedge PS2KeyboardClk)
//	begin
//	 case (IO_state)
//	 
//	 IDLING: begin  
//				bitCounter <= bitCounter + 4'b1;
//				IO_state <= SAMPLING;
//				
//	         end
//				
//	 SAMPLING: begin 
//	            if (bitCounter >= 1 && bitCounter <= 8)
//					begin
//						keyboardData[idx] <= PS2KeyboardData;
//						idx <= idx + 2'b1;
//				   end
//				   
//					if (bitCounter == 4'b1010)
//               begin
//					   if (keyboardData != 8'hf0)
//							   led <= keyboardData;
//							   //led <= 0;
//						
//						IO_state <= IDLING;		
//						bitCounter <= 0;
//						idx <= 0;
//						keyboardData <= 0;
//               end						
//				   else
//						bitCounter <= bitCounter + 4'b1;
//				  end
//	 endcase			  
//	end //end sequential block
//
//endmodule

module IO_Controller(
	input wire PS2KeyboardClk,// Clock pin form keyboard
	input wire PS2KeyboardData,//Data pin form keyboard
	output reg [7:0] led//Printing input data to led
	);
	
reg [7:0] data_curr;
reg [7:0] data_pre;
reg [3:0] b;
reg flag;

initial
begin
b<=4'h1;
flag<=1'b0;
data_curr<=8'hf0;
data_pre<=8'hf0;
led<=8'hf0;
end 

always @(negedge PS2KeyboardClk)
//Activating at negative edge of clock from keyboard
begin
	case(b)
	1:;
	//first bit
	2:data_curr[0]<=PS2KeyboardData;
	3:data_curr[1]<=PS2KeyboardData;
	4:data_curr[2]<=PS2KeyboardData;
	5:data_curr[3]<=PS2KeyboardData;
	6:data_curr[4]<=PS2KeyboardData;
	7:data_curr[5]<=PS2KeyboardData;
	8:data_curr[6]<=PS2KeyboardData;
	9:data_curr[7]<=PS2KeyboardData;
	10:flag<=1'b1;
	//Parity bit
	11:flag<=1'b0;
	//Ending bit
	endcase

	if(b<=10)
	b<=b + 4'b1;
	else if(b==11)
	b<=1;
	end 

	always@(posedge flag)
	// Printing data obtained to led
	begin 
	if(data_curr==8'hf0)
		led<=data_pre;
	else
		data_pre<=data_curr;
	end
endmodule
