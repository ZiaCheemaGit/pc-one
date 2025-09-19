`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2025 02:24:03 PM
// Design Name: 
// Module Name: mux_8X1
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


module mux_5x1 (
    input  [31:0] in0,
    input  [31:0] in1,
    input  [31:0] in2,
    input  [31:0] in3,
    input  [31:0] in4,
    input  [2:0]  sel,
    output reg [31:0] out
);

    always @(*) begin
        case (sel)
            3'b000: out = in0;
            3'b001: out = in1;
            3'b010: out = in2;
            3'b011: out = in3;
            3'b100: out = in4;
            default: out = 32'b0;
        endcase
    end

endmodule
