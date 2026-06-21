`timescale 1ns/1ps

module boot_rom(
    input clk,
    input wire [31:0] pc,          
    input wire [31:0] addr, 
    output reg [31:0] instruction,
    output reg [31:0] data
);

    parameter length = 32'h2000;
    parameter WORDS = length / 4; 

    reg [31:0] mem [0:WORDS-1];

    always @(posedge clk) begin
        instruction = mem[pc[31:2]];
    end

    assign data = mem[addr[31:2]]; 


    `ifndef SYNTHESIS
        string program_file;
        initial begin
            if (!$value$plusargs("PROGRAM_FILE=%s", program_file)) begin
                $display("ERROR: PROGRAM_FILE not specified!");
                $finish;
            end
            $display("Loading program from: %s", program_file);
            $readmemh(program_file, mem);
        end
    `elsif YOSYS
    `else
        initial begin
            $readmemh("D:/git-clones/pc-one/software/build/BIOS/bios.hex", mem);
        end
    `endif

endmodule



