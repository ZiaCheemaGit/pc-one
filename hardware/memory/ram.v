`timescale 1ns/1ps

module ram (
    input  wire        clk,
    input  wire [31:0] data_address,   // byte address from CPU
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] data_in,
    output reg  [31:0] data_out
);

    parameter MEM_SIZE = 16384;

    reg [31:0] mem [0:(MEM_SIZE/4)-1];

    wire [11:0] word_addr = data_address[13:2]; 
    
    always @(posedge clk) begin
        if (mem_write) begin
            mem[word_addr] <= data_in;
        end
    end

    always @(posedge clk) begin
        if (mem_read) begin
            data_out <= mem[word_addr];
        end else begin
                data_out <= 32'b0;
        end  
    end

endmodule
