module rom(
    input  wire [31:0] pc,          
    output wire  [31:0] instruction,
    input  wire [31:0] addr, 
    output wire [31:0] data
);

    parameter WORDS = 4096; // number of 32-bit words (16 KB total)

    // 32-bit wide ROM
    reg [31:0] mem [0:WORDS-1];

    assign data = mem[addr[31:2]];

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

    assign instruction = mem[word_index];

endmodule


