`timescale 1ns / 1ps

// works on cocotb
module ram_16KB(
    input clk,
    input [31:0] pc_address,
    output [31:0] instruction,
    input [31:0] data_address,
    input mem_read,
    input mem_write,
    input [31:0] data_in,
    output reg [31:0] data_out
);

    parameter MEM_SIZE = 16384;
    reg [7:0] mem [0:MEM_SIZE-1];

    //cocotb hex file
    `ifndef SYNTHESIS
        reg [1023:0] program_file;
        initial begin
            if (!$value$plusargs("PROGRAM_FILE=%s", program_file)) begin
                $display("ERROR: PROGRAM_FILE not specified!");
                $display("Run simulation with: +PROGRAM_FILE=<path_to_hex>");
                $finish;
            end

            $display("Loading program from: %s", program_file);
            $readmemh(program_file, mem);
        end
    `endif

    assign instruction = {
        mem[pc_address + 3], // MSB
        mem[pc_address + 2],
        mem[pc_address + 1],
        mem[pc_address]      // LSB
    };

    always @(posedge clk) begin
   
        if (mem_write) begin
            if (data_address < MEM_SIZE - 3) begin
                mem[data_address]     <= data_in[7:0];   // LSB
                mem[data_address + 1] <= data_in[15:8];
                mem[data_address + 2] <= data_in[23:16];
                mem[data_address + 3] <= data_in[31:24]; // MSB
            end
        end
    end

    always @(*) begin
        if (mem_read) begin
             if (data_address < MEM_SIZE - 3) begin
                data_out <= {
                    mem[data_address + 3],
                    mem[data_address + 2],
                    mem[data_address + 1],
                    mem[data_address]
                };
             end else begin
                data_out <= 32'b0;
             end
        end
    end

endmodule

// works on ise
// module ram_16KB(
//     input clk,
//     input [31:0] pc_address,
//     output reg [31:0] instruction,
//     input [31:0] data_address,
//     input mem_read,
//     input mem_write,
//     input [31:0] data_in,
//     output reg [31:0] data_out
// );

//     parameter WORDS = 4096;   // 16 KB / 4
//     reg [31:0] mem [0:WORDS-1];

//     wire [11:0] pc_word_addr   = pc_address[13:2];
//     wire [11:0] data_word_addr = data_address[13:2];

//     initial begin
//         $readmemh("test_uart_print_c.hex", mem);
//     end

//     always @(posedge clk) begin
//         instruction <= mem[pc_word_addr];

//         if (mem_write)
//             mem[data_word_addr] <= data_in;

//         if (mem_read)
//             data_out <= mem[data_word_addr];
//         else
//             data_out <= 32'b0;
//     end

// endmodule


// split ram rom 
// module instr_rom_8KB (
//     input  wire [31:0] pc_address,
//     output wire [31:0] instruction
// );

//     parameter ROM_SIZE = 8192; // 8 KB
//     reg [7:0] rom [0:ROM_SIZE-1];

// `ifndef SYNTHESIS
//     reg [1023:0] program_file;
//     initial begin
//         if (!$value$plusargs("PROGRAM_FILE=%s", program_file)) begin
//             $display("ERROR: PROGRAM_FILE not specified!");
//             $finish;
//         end
//         $display("Loading program from: %s", program_file);
//         $readmemh(program_file, rom);
//     end
// `endif

//     // Little-endian instruction fetch
//     assign instruction = (pc_address < ROM_SIZE-3) ? {
//         rom[pc_address + 3],
//         rom[pc_address + 2],
//         rom[pc_address + 1],
//         rom[pc_address]
//     } : 32'b0;

// endmodule

// module data_ram_8KB (
//     input  wire        clk,
//     input  wire        mem_read,
//     input  wire        mem_write,
//     input  wire [31:0] data_address,
//     input  wire [31:0] data_in,
//     output reg  [31:0] data_out
// );

//     parameter RAM_SIZE = 8192; // 8 KB
//     reg [7:0] ram [0:RAM_SIZE-1];

//     always @(posedge clk) begin
//         if (mem_write && data_address < RAM_SIZE-3) begin
//             ram[data_address]     <= data_in[7:0];
//             ram[data_address + 1] <= data_in[15:8];
//             ram[data_address + 2] <= data_in[23:16];
//             ram[data_address + 3] <= data_in[31:24];
//         end
//     end

//     always @(*) begin
//         if (mem_read && data_address < RAM_SIZE-3) begin
//             data_out = {
//                 ram[data_address + 3],
//                 ram[data_address + 2],
//                 ram[data_address + 1],
//                 ram[data_address]
//             };
//         end else begin
//             data_out = 32'b0;
//         end
//     end

// endmodule

// module ram_16KB (
//     input  wire        clk,
//     input  wire [31:0] pc_address,
//     output wire [31:0] instruction,
//     input  wire [31:0] data_address,
//     input  wire        mem_read,
//     input  wire        mem_write,
//     input  wire [31:0] data_in,
//     output wire [31:0] data_out
// );

//     // Address ranges
//     localparam ROM_BASE = 32'h0000_0000;
//     localparam ROM_SIZE = 8192;

//     localparam RAM_BASE = 32'h0000_2000;
//     localparam RAM_SIZE = 8192;

//     wire rom_sel = (data_address >= ROM_BASE) &&
//                    (data_address <  ROM_BASE + ROM_SIZE);

//     wire ram_sel = (data_address >= RAM_BASE) &&
//                    (data_address <  RAM_BASE + RAM_SIZE);

//     // Instruction ROM
//     instr_rom_8KB i_rom (
//         .pc_address(pc_address),
//         .instruction(instruction)
//     );

//     // Data RAM
//     data_ram_8KB i_ram (
//         .clk(clk),
//         .mem_read(mem_read && ram_sel),
//         .mem_write(mem_write && ram_sel), 
//         .data_address(data_address - RAM_BASE),
//         .data_in(data_in),
//         .data_out(data_out)
//     );

// endmodule