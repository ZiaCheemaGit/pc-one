module id_ex_reg(
    input wire clk,
    input wire rst,
    input wire reg_write_control_in,
    input wire [2:0] mem_to_reg_control_in,
    input wire byte_op_in,
    input wire unsigned_op_in,
    input wire half_op_in,
    input wire [31:0] pc_plus_u_type_immediate_value_in,
    output reg [31:0] pc_plus_u_type_immediate_value_out,
    output reg byte_op_out,
    output reg half_op_out,
    output reg unsigned_op_out,
    output reg reg_write_control_out,
    input wire [4:0] dest_reg_in,
    output reg [4:0] dest_reg_out,
    output reg [2:0] mem_to_reg_control_out,
    input wire [31:0] pc_plus_4_in,
    output reg [31:0] pc_plus_4_out,
    input wire [31:0] u_type_immediate_in,
    output reg [31:0] u_type_immediate_out,
    input wire mem_read_in,
    output reg mem_read_out,
    input wire mem_write_in,
    output reg mem_write_out,
    input wire [4:0] rs1_in,
    output reg [4:0] rs1_out,
    input wire [4:0] rs2_in,
    output reg [4:0] rs2_out,
    input wire [31:0] sign_ext_in,
    output reg [31:0] sign_ext_out,
    input wire [31:0] s_type_immediate_in,
    output reg [31:0] s_type_immediate_out,
    input wire [1:0] alu_src_control_in,
    output reg [1:0] alu_src_control_out,
    input wire invert_control_in,
    output reg invert_control_out,
    input wire [3:0] alu_control_in,
    output reg [3:0] alu_control_out
);

    always @(*) begin
        alu_control_out <= alu_control_in;
        invert_control_out <= invert_control_in;
        alu_src_control_out <= alu_src_control_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        mem_write_out <= mem_write_in;
        mem_read_out <= mem_read_in;
        dest_reg_out <= dest_reg_in;
        byte_op_out <= byte_op_in;
        half_op_out <= half_op_in;
        unsigned_op_out <= unsigned_op_in;
        reg_write_control_out <= reg_write_control_in; 
        pc_plus_u_type_immediate_value_out <= pc_plus_u_type_immediate_value_in;
        mem_to_reg_control_out <= mem_to_reg_control_in;
        pc_plus_4_out <= pc_plus_4_in;
        u_type_immediate_out <= u_type_immediate_in;
        sign_ext_out <= sign_ext_in;
        s_type_immediate_out <= s_type_immediate_in;
    end

endmodule
