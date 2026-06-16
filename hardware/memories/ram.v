`timescale 1ns/1ps

module ram (
    input  wire        clk,
    input  wire [31:0] data_address,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire        byte_op,
    input  wire        half_op,
    input  wire [31:0] data_in,
    output reg  [31:0] data_out
); 
    parameter length = 32'h2000;
    parameter WORDS = length / 4; 

    reg [31:0] mem [0:WORDS-1];

    wire [29:0] word_addr = data_address >> 2;

    reg [3:0]  we_mask;
    reg [31:0] aligned_data;

    // --------------------------------------------------------
    // Mask Generation and Data Alignment
    // --------------------------------------------------------
    always @(*) begin
        we_mask      = 4'b0000;
        aligned_data = data_in; // Default pass-through

        if (mem_write) begin
            if (byte_op) begin
                we_mask = 4'b0001 << data_address[1:0];
                aligned_data = data_in << ({data_address[1:0], 3'b000}); 
            end 
            else if (half_op) begin
                we_mask = data_address[1] ? 4'b1100 : 4'b0011;
                aligned_data = data_address[1] ? (data_in << 16) : data_in;
            end 
            else begin
                we_mask = 4'b1111;
            end
        end
    end

    // --------------------------------------------------------
    // Synchronous Write
    // --------------------------------------------------------
    always @(posedge clk) begin
        // If data_address is lower than RAM_BASE, word_addr will underflow 
        // to a huge number, safely failing this bounds check.
        if (word_addr < WORDS) begin
            if (we_mask[0]) mem[word_addr][7:0]   <= aligned_data[7:0];
            if (we_mask[1]) mem[word_addr][15:8]  <= aligned_data[15:8];
            if (we_mask[2]) mem[word_addr][23:16] <= aligned_data[23:16];
            if (we_mask[3]) mem[word_addr][31:24] <= aligned_data[31:24];
        end
    end

    // --------------------------------------------------------
    // Asynchronous Read
    // --------------------------------------------------------
    always @(*) begin
        if (mem_read) begin
            if (word_addr < WORDS)
                data_out = mem[word_addr];
            else
                data_out = 32'h00000000; 
        end else begin
            data_out = 32'h00000000; 
        end
    end

endmodule

