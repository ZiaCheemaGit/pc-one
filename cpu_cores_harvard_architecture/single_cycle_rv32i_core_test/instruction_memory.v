`timescale 1ns / 1ps

module instruction_memory(
    input clk,
    input [31:0] address,
    output reg [31:0] instruction
    );
    
    reg [7:0] mem [0:2047];
    
    initial begin
        mem[0] = 8'b0;
    end
    
    always @(posedge clk) begin
        instruction <= {mem[{address[31:2], 2'b00} + 3], 
                       mem[{address[31:2], 2'b00} + 2], 
                       mem[{address[31:2], 2'b00} + 1], 
                       mem[{address[31:2], 2'b00}]};
    end
    
endmodule

