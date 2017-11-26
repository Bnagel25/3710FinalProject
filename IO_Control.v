`timescale 1ns / 1ps

module IO_Controller(
    input PS2KeyboardClk,
    input PS2KeyboardData,
    output reg [7:0] IO_to_memcon_data,
	 output reg [7:0] led
    );

	//Internal registers for holding data
	reg [7:0] keyboardData;
	reg [3:0] bitCounter;
	reg [1:0] IO_state;
	reg [2:0] idx;
	
	//bit counter for incoming data bits
	initial bitCounter = 0;
	initial idx = 0;
	
	//led output
	initial led = 1;	
	
	//initial state
	initial IO_state = IDLING;

	//States
	parameter IDLING   = 2'b00;
	parameter SAMPLING = 2'b01;

	//Sequential logic 
   always@(negedge PS2KeyboardClk)
	begin
	 case (IO_state)
	 
	 IDLING: begin  
				bitCounter <= bitCounter + 4'b1;
				IO_state <= SAMPLING;
	         end //end idling
				
	 SAMPLING: begin 
	            if (bitCounter >= 1 && bitCounter <= 8)
					begin
						keyboardData[idx] <= PS2KeyboardData;
						idx <= idx + 2'b1;
				   end
				   
					if (bitCounter == 4'b1010)
               begin
					   if (keyboardData != 8'hf0)
							begin
							led <= keyboardData;
							IO_to_memcon_data <= keyboardData;
							end
						
					   IO_state <= IDLING;		
						bitCounter <= 0;
						idx <= 0;
						keyboardData <= 0;
               end						
				   else
						bitCounter <= bitCounter + 4'b1;
				  end//end sampling
	 endcase	//end case statement		  
	end //end sequential block
endmodule