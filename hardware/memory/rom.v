module rom(
    input  wire        clk,
    input  wire [31:0] pc,       
    output reg  [31:0] instruction
);

    parameter WORDS = 16384;
    reg [7:0] mem [0:WORDS-1];

    // for cocotb 
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
    // for ISE Design Suite
    `else
        initial begin
        $readmemh("D:/git-clones/pc-one/tests/pc_one/test_cases/generated_hex/asm_tests_test_basic_asm/test_basic_asm.hex", mem);
        end
    `endif

    always @(posedge clk) begin
        instruction <= mem[pc];
    end
endmodule

