module ram (
    input  wire        clk,
    input  wire [31:0] data_address,   // byte address from CPU
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] data_in,
    output reg  [31:0] data_out
);

    // 8 KB RAM = 2048 words
    parameter WORDS = 4096;

    reg [31:0] mem [0:WORDS-1];

    wire [11:0] word_addr = data_address[13:2];

    always @(posedge clk) begin
        if (mem_write) begin
            mem[word_addr] <= data_in;
        end
    end

    always @(*) begin
    if (mem_read)
        data_out = mem[word_addr];
    else
        data_out = 32'b0;
end


endmodule
