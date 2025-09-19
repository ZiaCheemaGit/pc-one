`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 12:48:31 PM
// Design Name: 
// Module Name: shift_left_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module shift_left_1(
    input [31:0] in,
    output [31:0] out
    );
    
    assign out = in << 1;
    
endmodule
