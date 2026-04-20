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

    parameter length = 32'h800;
    reg [31:0] mem [0:(length/4)-1];

    wire [9:0] word_addr = data_address[11:2];
    wire [1:0] byte_offset = data_address[1:0];

    reg [3:0] we;

    always @(posedge clk) begin
        if(!mem_write)
            we = 4'b0000;
        else if(byte_op)
            case (byte_offset)
                2'b00: we = 4'b0001;
                2'b01: we = 4'b0010;
                2'b10: we = 4'b0100;
                2'b11: we = 4'b1000;
            endcase
        else if(half_op)
            case (byte_offset[1])
                1'b0: we = 4'b0011;
                1'b1: we = 4'b1100;
            endcase
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
            data_out = mem[word_addr];
        else
            data_out = 32'b0;
    end

endmodule

// module ram (
//     input  wire        clk,
//     input  wire [31:0] data_address,
//     input  wire        mem_read,
//     input  wire        mem_write,
//     input  wire        byte_op,
//     input  wire        half_op,
//     input  wire [31:0] data_in,
//     output reg  [31:0] data_out
// );

//     parameter length = 32'h2000;

//     // true byte-addressable storage
//     reg [7:0] mem [0:length-1];

//     wire [10:0] addr = data_address[10:0];  

//     // ---------------- WRITE LOGIC ----------------

//     always @(posedge clk) begin
//         if(mem_write) begin

//             if(byte_op) begin
//                 mem[addr] <= data_in[7:0];
//             end

//             else if(half_op) begin
//                 mem[addr]     <= data_in[7:0];
//                 mem[addr + 1] <= data_in[15:8];
//             end

//             else begin
//                 mem[addr]     <= data_in[7:0];
//                 mem[addr + 1] <= data_in[15:8];
//                 mem[addr + 2] <= data_in[23:16];
//                 mem[addr + 3] <= data_in[31:24];
//             end

//         end
//     end


//     // ---------------- READ LOGIC ----------------

//     always @(*) begin
//         if(mem_read) begin
//             data_out = {
//                 mem[addr + 3],
//                 mem[addr + 2],
//                 mem[addr + 1],
//                 mem[addr]
//             };
//         end
//         else begin
//             data_out = 32'b0;
//         end
//     end

// endmodule