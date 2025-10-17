`timescale 1ns / 1ps

/**
12 to 32 bit sign extender
**/

module sign_ext_12_to_32(
    input [31:0] instruction,
    output [31:0] out, u_type_immediate, jal_offset
    );
    
    assign jal_offset = {{12{instruction[31]}}, instruction[31:12]};
    assign out = {{20{instruction[31]}}, instruction[31:20]};
    assign u_type_immediate = {instruction[31:12], 12'b0};
    
endmodule
