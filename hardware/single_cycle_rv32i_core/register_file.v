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

    always @(rst) begin
        if (rst) begin
            registers[0] <= 32'd0;
            registers[1] <= 32'd0;
            registers[2] <= 32'd0;
            registers[3] <= 32'd0;
            registers[4] <= 32'd0;
            registers[5] <= 32'd0;
            registers[6] <= 32'd0;
            registers[7] <= 32'd0;
            registers[8] <= 32'd0;
            registers[9] <= 32'd0;
            registers[10] <= 32'd0;
            registers[11] <= 32'd0;
            registers[12] <= 32'd0;
            registers[13] <= 32'd0;
            registers[14] <= 32'd0;
            registers[15] <= 32'd0;
            registers[16] <= 32'd0;
            registers[17] <= 32'd0;
            registers[18] <= 32'd0;
            registers[19] <= 32'd0;
            registers[20] <= 32'd0;
            registers[21] <= 32'd0;
            registers[22] <= 32'd0;
            registers[23] <= 32'd0;
            registers[24] <= 32'd0;
            registers[25] <= 32'd0;
            registers[26] <= 32'd0;
            registers[27] <= 32'd0;
            registers[28] <= 32'd0;
            registers[29] <= 32'd0;
            registers[30] <= 32'd0;
            registers[31] <= 32'd0;
        end 
    end

    // always @(posedge clk) begin
    //     if (reg_write_control && dest_reg != 5'd0 && !rst) begin
    //         registers[dest_reg] <= reg_write_data;
    //     end
    // end

    // assign src1_reg_value = registers[src1_reg];
    // assign src2_reg_value = registers[src2_reg];

    assign src1_reg_value = (src1_reg == 5'd0) ? 32'd0 : registers[src1_reg];
    assign src2_reg_value = (src2_reg == 5'd0) ? 32'd0 : registers[src2_reg];

endmodule
