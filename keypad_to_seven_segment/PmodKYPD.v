`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc 2011
// Engineer: Michelle Yu  
//				 Josh Sackos
// Create Date:    17:05:39 08/23/2011 
//
// Module Name:    PmodKYPD
// Project Name:   PmodKYPD_Demo
// Target Devices: Nexys3
// Tool versions:  Xilinx ISE 14.1 
// Description: This file defines a project that outputs the key pressed on the PmodKYPD to the 
//					 seven segment display.
//
// Revision History: 
// 						Revision 0.01 - File Created (Michelle Yu)
//							Revision 0.01 - Converted from VHDL to Verilog (Josh Sackos)
//////////////////////////////////////////////////////////////////////////////////////////////////////////

// ==============================================================================================
// 												Define Module
// ==============================================================================================
module PmodKYPD(
    clk,
	btnR,
	btnL,
    JA,
    an,
    seg,
	led
    );
	 
	 
// ==============================================================================================
// 											Port Declarations
// ==============================================================================================
	input btnR;
	input btnL;		// Button C
	input clk;					// 100Mhz onboard clock
	inout [7:0] JA;			// Port JA on Nexys3, JA[3:0] is Columns, JA[10:7] is rows
	output [3:0] an;			// Anodes on seven segment display
	output [6:0] seg;			// Cathodes on seven segment display
	output [15:0] led;			// LEDs on Nexys3

// ==============================================================================================
// 							  		Parameters, Regsiters, and Wires
// ==============================================================================================
	
	// Output wires
	wire [3:0] an;
	wire [6:0] seg;
	wire [3:0] hex_val;
	wire [3:0] Decode;
	wire [15:0] led;

    wire debounced_btnR;
    wire debounced_btnL;

// ==============================================================================================
// 												Implementation
// ==============================================================================================

	//-----------------------------------------------
	//  						Decoder
	//-----------------------------------------------
	Decoder C0(
			.clk(clk),
			.Row(JA[7:4]),
			.Col(JA[3:0]),
			.DecodeOut(Decode)
	);

    Debouncing debouncerR(
        .clk(clk),
        .pb_1(btnR),
        .pb_out(debounced_btnR)
    );
    
    Debouncing debouncerL(
        .clk(clk),
        .pb_1(btnL),
        .pb_out(debounced_btnL)
    );

	//-----------------------------------------------
	//  		Seven Segment Display Controller
	//-----------------------------------------------
	DisplayController C1(
			.btnR(debounced_btnR),
			.btnL(debounced_btnL),
			.DispVal(Decode),
			.clock(clk),
			.anode(an),
			.hex_out(hex_val),
			.led(led)
	);
	
	HexToLED C3(
	       .hex(hex_val),
	       .seg(seg)
	);
	       

endmodule
