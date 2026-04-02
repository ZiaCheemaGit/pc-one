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

    parameter length = 32'h00000800;
    reg [31:0] mem [0:(length/4)-1];

    wire [13:0] word_addr = data_address[15:2];
    wire [1:0] byte_offset = data_address[1:0];

    reg [3:0] we;

    always @(*) begin
        if(!mem_write)
            we = 4'b0000;
        else if(byte_op)
            we = (byte_offset==2'b00)?4'b0001:
                 (byte_offset==2'b01)?4'b0010:
                 (byte_offset==2'b10)?4'b0100:
                                    4'b1000;
        else if(half_op)
            we = (byte_offset[1]==0)?4'b0011: 4'b1100;
        else
            we = 4'b1111;
    end

    always @(posedge clk) begin
        if(we[0]) mem[word_addr][7:0]   <= data_in[7:0];
        if(we[1]) mem[word_addr][15:8]  <= data_in[15:8];
        if(we[2]) mem[word_addr][23:16] <= data_in[23:16];
        if(we[3]) mem[word_addr][31:24] <= data_in[31:24];

    end

    always @(*) begin
        if(mem_read)
            data_out <= mem[word_addr];
        else
            data_out <= 32'b0;
    end

endmodule
