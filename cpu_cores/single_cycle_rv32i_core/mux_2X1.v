`timescale 1ns / 1ps

module mux_2X1(
    input [31:0] in0,
    input [31:0] in1,
    input sel,
    output [31:0] out
    );
    
    assign out = (sel == 0) ? in0 : in1;
    
endmodule
