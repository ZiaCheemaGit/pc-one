// passes test_basic_asm.S, test_load_asm.S and test_load_neg_asm.S  
// fails test_math_c.c and test_aggressive_c.c
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

    parameter RAM_DEPTH = 4096; 
    parameter RAM_BASE  = 32'h2000; // Explicitly mount RAM at 0x2000

    reg [31:0] mem [0:RAM_DEPTH-1];

    // Initialize memory to prevent X states
    integer i;
    initial begin
        for (i = 0; i < RAM_DEPTH; i = i + 1) begin
            mem[i] = 32'h00000000;
        end
    end

    // Subtract the base address so 0x2000 strictly maps to index 0
    wire [29:0] word_addr = (data_address - RAM_BASE) >> 2;

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
        if (word_addr < RAM_DEPTH) begin
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
            if (word_addr < RAM_DEPTH)
                data_out = mem[word_addr];
            else
                data_out = 32'h00000000; 
        end else begin
            data_out = 32'h00000000; 
        end
    end

endmodule

// passes test_basic_asm.S, test_load_asm.S and test_math_c.c
// fails test_load_neg_asm.S and test_aggressive_c.c
// `timescale 1ns/1ps

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

//     parameter length = 32'h800;
//     reg [31:0] mem [0:(length/4)-1];

//     wire [9:0] word_addr = data_address[11:2];
//     wire [1:0] byte_offset = data_address[1:0];

//     reg [3:0] we;

//     always @(*) begin
//         if(!mem_write)
//             we = 4'b0000;
//         else if(byte_op)
//             we = (byte_offset==2'b00)?4'b0001:
//                  (byte_offset==2'b01)?4'b0010:
//                  (byte_offset==2'b10)?4'b0100:
//                                     4'b1000;
//         else if(half_op)
//             we = (byte_offset[1]==0)?4'b0011: 4'b1100;
//         else
//             we = 4'b1111;
//     end

//     always @(posedge clk) begin
//         if(we[0]) mem[word_addr][7:0]   <= data_in[7:0];
//         if(we[1]) mem[word_addr][15:8]  <= data_in[15:8];
//         if(we[2]) mem[word_addr][23:16] <= data_in[23:16];
//         if(we[3]) mem[word_addr][31:24] <= data_in[31:24];

//     end

//     always @(*) begin
//         if(mem_read)
//             data_out <= mem[word_addr];
//         else
//             data_out <= 32'b0;
//     end

// endmodule
