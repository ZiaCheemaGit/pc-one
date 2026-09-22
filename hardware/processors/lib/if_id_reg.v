module if_id_reg (
    input wire clk,
    input wire rst,
    input wire en,
    input wire flush,
    input wire [31:0] pc_in,   
    input wire [31:0] inst_in,
    input wire [31:0] pc_plus_4_in,
    output reg [31:0] pc_plus_4_out,
    output reg [31:0] pc_out,
    output wire [31:0] inst_out
);

    reg flush_delay;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out      <= 32'b0;
            flush_delay <= 1'b0;
            pc_plus_4_out <= 32'b0;
        end else if (en) begin
            pc_out      <= pc_in;
            flush_delay <= flush;
            pc_plus_4_out <= pc_plus_4_in;
        end
    end
    
    assign inst_out = (flush_delay || rst) ? 32'b0 : inst_in;
    
endmodule
