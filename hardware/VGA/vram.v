`timescale 1ns / 1ps

module vram(
	input [7:0] color,
	input [17:0] address,
	output [7:0] data
);
	 
	assign data = ram[address];

	// 58 KB VRam
	reg [2:0] ram [0:153599];
	
endmodule

