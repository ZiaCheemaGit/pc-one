module rom(
    input  wire        clk,
    input  wire [31:0] pc,          // byte address (unchanged)
    output reg  [31:0] instruction  // 32-bit instruction
);

    parameter WORDS = 4096; // number of 32-bit words (16 KB total)

    // 32-bit wide ROM
    reg [31:0] mem [0:WORDS-1];

    // for cocotb
    `ifndef SYNTHESIS
        reg [1023:0] program_file;
        initial begin
            if (!$value$plusargs("PROGRAM_FILE=%s", program_file)) begin
                $display("ERROR: PROGRAM_FILE not specified!");
                $finish;
            end
            $display("Loading program from: %s", program_file);
            $readmemh(program_file, mem);
        end
    // for ISE Design Suite
    `else
        initial begin
        $readmemh("D:/git-clones/pc-one/tests/pc_one/test_cases/generated_hex/asm_tests_test_basic_asm/test_basic_asm.hex", mem);
        end
    `endif

    wire [31:0] word_index;
    assign word_index = pc[31:2];  

    always @(posedge clk) begin
        instruction <= mem[word_index];
    end

endmodule


