`timescale 1ns / 1ps

module pc(
    input clk,
    input rst,
    input enable,
    input [31:0] jump_address,
    output reg [31:0] pc_next
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_next <= 32'b0;   
        end else if (enable) begin
            pc_next <= jump_address;
        end
    end
    
endmodule
