module ram (
    input  wire        clk,
    input  wire [31:0] data_address,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] data_in,
    output reg  [31:0] data_out
);

    parameter MEM_SIZE = 8192;  

    reg [7:0] mem [0:MEM_SIZE-1];

    wire [14:0] addr = data_address[12:0];

    // Write
    always @(posedge clk) begin
        if (mem_write && addr < MEM_SIZE - 3) begin
            mem[addr]     <= data_in[7:0];
            mem[addr + 1] <= data_in[15:8];
            mem[addr + 2] <= data_in[23:16];
            mem[addr + 3] <= data_in[31:24];
        end
    end

    // Read
    always @(*) begin
        if (mem_read && addr < MEM_SIZE - 3) begin
            data_out = {
                mem[addr + 3],
                mem[addr + 2],
                mem[addr + 1],
                mem[addr]
            };
        end else begin
            data_out = 32'b0;
        end
    end

endmodule
