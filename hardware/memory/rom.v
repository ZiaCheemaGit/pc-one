`timescale 1ns/1ps

module rom(
    input wire byte_op,
    input wire half_op,
    input wire unsigned_op, 
    input wire [31:0] pc,          
    output wire [31:0] instruction,
    input wire [31:0] addr, 
    output wire [31:0] data
);

    parameter WORDS = 4096; 

    reg [31:0] mem [0:WORDS-1];

    // FIX: missing declaration
    wire [31:0] read_word;
    assign read_word = mem[addr[31:2]];

    wire [1:0] byte_offset;
    assign byte_offset = addr[1:0];

    reg [31:0] data_reg;

    always @(*) begin
        if (byte_op) begin
            case (byte_offset)
                2'b00: data_reg = unsigned_op ?
                    {24'b0, read_word[7:0]} :
                    {{24{read_word[7]}}, read_word[7:0]};

                2'b01: data_reg = unsigned_op ?
                    {24'b0, read_word[15:8]} :
                    {{24{read_word[15]}}, read_word[15:8]};

                2'b10: data_reg = unsigned_op ?
                    {24'b0, read_word[23:16]} :
                    {{24{read_word[23]}}, read_word[23:16]};

                2'b11: data_reg = unsigned_op ?
                    {24'b0, read_word[31:24]} :
                    {{24{read_word[31]}}, read_word[31:24]};
            endcase
        end
        else if (half_op) begin
            case (byte_offset[1])
                1'b0: data_reg = unsigned_op ?
                    {16'b0, read_word[15:0]} :
                    {{16{read_word[15]}}, read_word[15:0]};

                1'b1: data_reg = unsigned_op ?
                    {16'b0, read_word[31:16]} :
                    {{16{read_word[31]}}, read_word[31:16]};
            endcase
        end
        else begin
            data_reg = read_word;
        end
    end

    assign data = data_reg;

    // instruction fetch path (unchanged)
    wire [31:0] word_index;
    assign word_index = pc[31:2];

    assign instruction = mem[word_index];

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
    `else
        initial begin
            $readmemh("D:/git-clones/pc-one/software/build/rom_image.hex", mem);
        end
    `endif

endmodule



