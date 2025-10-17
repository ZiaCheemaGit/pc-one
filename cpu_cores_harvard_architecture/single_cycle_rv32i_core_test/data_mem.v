`timescale 1ns / 1ps

module data_mem(
    input clk,
    input [31:0] address,
    input mem_read,
    input mem_write,
    input [31:0] data_in,
    output reg [31:0] data_out
    );
    
    reg [7:0] mem [0:1023];
    
    always @(posedge clk) begin
        if (mem_write) begin
            mem[{address[31:2], 2'b00} + 3] <= data_in[31:24];
            mem[{address[31:2], 2'b00} + 2] <= data_in[23:16];
            mem[{address[31:2], 2'b00} + 1] <= data_in[15:8];
            mem[{address[31:2], 2'b00}]     <= data_in[7:0];
        end
    end
    
    always @(posedge clk) begin
        if (mem_read) begin
            data_out <= {mem[{address[31:2], 2'b00} + 3],
                         mem[{address[31:2], 2'b00} + 2],
                         mem[{address[31:2], 2'b00} + 1],
                         mem[{address[31:2], 2'b00}]};
        end else begin
            data_out <= 32'b0;
        end
    end
    
endmodule
