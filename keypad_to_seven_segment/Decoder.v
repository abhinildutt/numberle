`timescale 1ns / 1ps

module Decoder(
    clk,
    Row,
    Col,
    DecodeOut,
    btnR
    );

    input clk;
    input btnR;
    input [3:0] Row;
    output [3:0] Col;
    output [3:0] DecodeOut;

	reg [3:0] Col;
	reg [3:0] DecodeOut;
	
	reg [19:0] sclk;
    
	integer state = 1;
    integer prev_state = 0; 


    always @(posedge btnR) begin
	   state <= state + 1;
	end

	always @(posedge clk) begin
			if(prev_state != state) begin
                DecodeOut <= 4'b1111;
                prev_state <= state;
            end    

			// 1ms
			if (sclk == 20'b00011000011010100000) begin
				//C1
				Col <= 4'b0111;
				sclk <= sclk + 1'b1;
			end
			
			// check row pins
			else if(sclk == 20'b00011000011010101000) begin
				//R1
				if (Row == 4'b0111) begin
					DecodeOut <= 4'b0001;		//1
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 4'b0100; 		//4
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 4'b0111; 		//7
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 4'b0000; 		//0
				end
				sclk <= sclk + 1'b1;
			end

			// 2ms
			else if(sclk == 20'b00110000110101000000) begin
				//C2
				Col<= 4'b1011;
				sclk <= sclk + 1'b1;
			end
			
			// check row pins
			else if(sclk == 20'b00110000110101001000) begin
				//R1
				if (Row == 4'b0111) begin
					DecodeOut <= 4'b0010; 		//2
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 4'b0101; 		//5
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 4'b1000; 		//8
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 4'b1111; 		//F
				end
				sclk <= sclk + 1'b1;
			end

			//3ms
			else if(sclk == 20'b01001001001111100000) begin
				//C3
				Col<= 4'b1101;
				sclk <= sclk + 1'b1;
			end
			
			// check row pins
			else if(sclk == 20'b01001001001111101000) begin
				//R1
				if(Row == 4'b0111) begin
					DecodeOut <= 4'b0011; 		//3	
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 4'b0110; 		//6
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 4'b1001; 		//9
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 4'b1110; 		//E
				end

				sclk <= sclk + 1'b1;
			end

			//4ms
			else if(sclk == 20'b01100001101010000000) begin
				//C4
				Col<= 4'b1110;
				sclk <= sclk + 1'b1;
			end

			// Check row pins
			else if(sclk == 20'b01100001101010001000) begin
				//R1
				if(Row == 4'b0111) begin
					DecodeOut <= 4'b1010; //A
				end
				//R2
				else if(Row == 4'b1011) begin
					DecodeOut <= 4'b1011; //B
				end
				//R3
				else if(Row == 4'b1101) begin
					DecodeOut <= 4'b1100; //C
				end
				//R4
				else if(Row == 4'b1110) begin
					DecodeOut <= 4'b1101; //D
				end
				sclk <= 20'b00000000000000000000;
			end

			// Otherwise increment
			else begin
				sclk <= sclk + 1'b1;
			end
			
	end

endmodule
