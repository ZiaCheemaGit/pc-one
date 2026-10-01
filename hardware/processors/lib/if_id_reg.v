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
    reg [31:0] inst_hold_reg;
    reg is_stalled;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out        <= 32'b0;
            flush_delay   <= 1'b0;
            pc_plus_4_out <= 32'b0;
            inst_hold_reg <= 32'b0;
            is_stalled    <= 1'b0;
        end else begin
            is_stalled <= !en;
            
            if (en) begin
                pc_out        <= pc_in;
                flush_delay   <= flush;
                pc_plus_4_out <= pc_plus_4_in;
            end else if (!is_stalled) begin
                // At the exact moment 'en' drops (stall begins), 
                // capture the live instruction from the ROM so it isn't lost.
                inst_hold_reg <= inst_in;
            end
        end
    end
    
    // If we are stalled, output the safely held instruction. 
    // Otherwise, let the live ROM output flow through normally.
    wire [31:0] actual_inst = is_stalled ? inst_hold_reg : inst_in;
    
    assign inst_out = (flush_delay || rst) ? 32'b0 : actual_inst;
    
endmodule
