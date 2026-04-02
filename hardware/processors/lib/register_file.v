`timescale 1ns / 1ps

/**
RV32I 32 X 32 register file
**/

module reg_file (
    input clk,
    input rst,
    input [4:0] dest_reg, src1_reg, src2_reg,
    input [31:0] reg_write_data,
    input reg_write_control,
    output [31:0] src1_reg_value, src2_reg_value
);

    reg [31:0] registers [0:31];

   integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end else if (reg_write_control && dest_reg != 0) begin
            registers[dest_reg] <= reg_write_data;
        end
    end

    assign src1_reg_value = registers[src1_reg];
    assign src2_reg_value = registers[src2_reg];

endmodule
