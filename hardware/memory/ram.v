`timescale 1ns/1ps


module ram (
    input  wire        clk,
    input  wire [31:0] data_address,   
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire        byte_op,
    input  wire        half_op,
    input  wire        unsigned_op,   
    input  wire [31:0] data_in,
    output reg  [31:0] data_out
);

    parameter MEM_SIZE = 16384;

    reg [31:0] mem [0:(MEM_SIZE/4)-1];

    wire [11:0] word_addr  = data_address[13:2];
    wire [1:0]  byte_offset = data_address[1:0];

    reg [31:0] read_word;
    reg [31:0] write_word;

    always @(posedge clk) begin
        if (mem_write) begin
            write_word = mem[word_addr];

            if (byte_op) begin
                case (byte_offset)
                    2'b00: write_word[7:0]   = data_in[7:0];
                    2'b01: write_word[15:8]  = data_in[7:0];
                    2'b10: write_word[23:16] = data_in[7:0];
                    2'b11: write_word[31:24] = data_in[7:0];
                endcase
            end
            else if (half_op) begin
                case (byte_offset[1])
                    1'b0: write_word[15:0]  = data_in[15:0];
                    1'b1: write_word[31:16] = data_in[15:0];
                endcase
            end
            else begin
                write_word = data_in;
            end

            mem[word_addr] <= write_word;
        end
    end

    always @(*) begin
        if (mem_read) begin
            read_word = mem[word_addr];

            if (byte_op) begin
                case (byte_offset)
                    2'b00: data_out <= unsigned_op ?
                        {24'b0, read_word[7:0]} :
                        {{24{read_word[7]}}, read_word[7:0]};
                    2'b01: data_out <= unsigned_op ?
                        {24'b0, read_word[15:8]} :
                        {{24{read_word[15]}}, read_word[15:8]};
                    2'b10: data_out <= unsigned_op ?
                        {24'b0, read_word[23:16]} :
                        {{24{read_word[23]}}, read_word[23:16]};
                    2'b11: data_out <= unsigned_op ?
                        {24'b0, read_word[31:24]} :
                        {{24{read_word[31]}}, read_word[31:24]};
                endcase
            end
            else if (half_op) begin
                case (byte_offset[1])
                    1'b0: data_out <= unsigned_op ?
                        {16'b0, read_word[15:0]} :
                        {{16{read_word[15]}}, read_word[15:0]};
                    1'b1: data_out <= unsigned_op ?
                        {16'b0, read_word[31:16]} :
                        {{16{read_word[31]}}, read_word[31:16]};
                endcase
            end
            else begin
                data_out <= read_word;
            end
        end
        else begin
            data_out <= 32'b0;
        end
    end

endmodule
