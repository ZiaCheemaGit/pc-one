/**
RV32I 32 X 32 register file
**/

module reg_file (
    input clk,
    input [4:0] dest_reg, src1_reg, src2_reg,
    input [31:0] reg_write_data,
    input reg_write_control,
    output [31:0] src1_reg_value, src2_reg_value
);

    reg [31:0] registers [0:31];

    always @(posedge clk) begin
        if (reg_write_control && dest_reg != 5'd0) begin
            registers[dest_reg] <= reg_write_data;
        end
    end

    assign src1_reg_value = registers[src1_reg];
    assign src2_reg_value = registers[src2_reg];

endmodule
