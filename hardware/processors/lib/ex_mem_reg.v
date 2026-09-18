`timescale 1ns / 1ps

module ex_mem_reg(
    input rst,
    input clk,
    input wire [31:0] alu_result_in,
    output reg [31:0] alu_result_out,
    input wire [31:0] mem_address_in,
    output reg [31:0] mem_address_out,
    input wire reg_write_control_in,
    input wire byte_op_in,
    input wire half_op_in,
    input wire unsigned_op_in,
    output reg byte_op_out,
    output reg half_op_out,
    output reg unsigned_op_out,
    output reg reg_write_control_out,
    input wire [4:0] dest_reg_in,
    output reg [4:0] dest_reg_out,
    input wire [2:0] mem_to_reg_control_in,
    output reg [2:0] mem_to_reg_control_out,
    input wire [31:0] pc_plus_4_in,
    output reg [31:0] pc_plus_4_out,
    input wire [31:0] pc_plus_u_type_immediate_in,
    output reg [31:0] pc_plus_u_type_immediate_out,
    input wire [31:0] u_type_immediate_in,
    output reg [31:0] u_type_immediate_out,
    input wire mem_read_in,
    output reg mem_read_out
); 

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            mem_address_out <= 32'b0;
            byte_op_out <= 1'b0;
            half_op_out <= 1'b0;
            unsigned_op_out <= 1'b0;
            alu_result_out <= 32'b0;
            reg_write_control_out <= 1'b0;
            dest_reg_out <= 5'b0;
            mem_to_reg_control_out <= 3'b0;
            pc_plus_4_out <= 32'b0;
            pc_plus_u_type_immediate_out <= 32'b0;
            u_type_immediate_out <= 32'b0;
            mem_read_out <= 1'b0;
        end else begin
            mem_address_out <= mem_address_in;
            byte_op_out <= byte_op_in;
            half_op_out <= half_op_in;
            unsigned_op_out <= unsigned_op_in;
            alu_result_out <= alu_result_in;
            reg_write_control_out <= reg_write_control_in;
            dest_reg_out <= dest_reg_in;
            mem_to_reg_control_out <= mem_to_reg_control_in;
            pc_plus_4_out <= pc_plus_4_in;
            pc_plus_u_type_immediate_out <= pc_plus_u_type_immediate_in;
            u_type_immediate_out <= u_type_immediate_in;
            mem_read_out <= mem_read_in;
        end
    end

endmodule
