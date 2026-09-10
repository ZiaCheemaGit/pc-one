`timescale 1ns / 1ps

module ex_mem_reg(
    input wire [31:0] alu_result_in,
    output wire [31:0] alu_result_out,
    input wire [31:0] mem_address_in,
    output wire [31:0] mem_address_out,
    input wire reg_write_control_in,
    input wire byte_op_in,
    input wire half_op_in,
    input wire unsigned_op_in,
    output wire byte_op_out,
    output wire half_op_out,
    output wire unsigned_op_out,
    output wire reg_write_control_out,
    input wire [4:0] dest_reg_in,
    output wire [4:0] dest_reg_out,
    input wire [2:0] mem_to_reg_control_in,
    output wire [2:0] mem_to_reg_control_out,
    input wire [31:0] pc_plus_4_in,
    output wire [31:0] pc_plus_4_out,
    input wire [31:0] pc_plus_u_type_immediate_in,
    output wire [31:0] pc_plus_u_type_immediate_out,
    input wire [31:0] u_type_immediate_in,
    output wire [31:0] u_type_immediate_out
); 
    assign mem_address_out = mem_address_in;
    assign byte_op_out = byte_op_in;
    assign half_op_out = half_op_in;
    assign unsigned_op_out = unsigned_op_in;
    assign alu_result_out = alu_result_in;
    assign reg_write_control_out = reg_write_control_in;
    assign dest_reg_out = dest_reg_in;
    assign mem_to_reg_control_out = mem_to_reg_control_in;
    assign pc_plus_4_out = pc_plus_4_in;
    assign pc_plus_u_type_immediate_out = pc_plus_u_type_immediate_in;
    assign u_type_immediate_out = u_type_immediate_in;

endmodule
