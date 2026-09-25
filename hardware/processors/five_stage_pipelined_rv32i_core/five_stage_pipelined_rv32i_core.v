`timescale 1ns / 1ps

/*

So the pc in fetch cycle is updated and the instruction is only captured in 
next cycle directly. This is because rom is synchronus and has a one cycle delay 
of its own.

Similarly the load/store controls are sent to memory directly from execute stage and 
load happens in next cycle. The ram is also synchronus and has one cycle delay. That is 
why a store instruction is directly retired in execute stage.   

*/

module core(
    input clk,
    input rst,
    input [31:0] instruction,
    input [31:0] mem_data_from_mem,
    output [31:0] instruction_address,
    output mem_write_request,
    output mem_read_request,
    output mem_read,
    output byte_op,
    output half_op,
    output [31:0] mem_address,
    output [31:0] mem_address_request,
    output [31:0] mem_data_to_mem
);

    wire [31:0] pc_plus_immediate_value, b_type_immediate_from_sign_ext_instance,
    pc_value_from_if_id, pc_plus_jal_offset_value, jal_offset_from_sign_ext_instance, jalr_pc, 
    alu_out_from_main_alu_instance, pc_jump_add, pc_value, pc_plus_4_value, 
    instruction_from_if_id, sign_ext_from_sign_ext_instance, 
    u_type_immediate_from_sign_ext_instance, s_type_immediate_from_sign_ext_instance, 
    alu_out_from_ex_mem, pc_plus_4, pc_plus_4_from_ex_mem, pc_plus_u_type_immediate_value, 
    pc_plus_u_type_immediate_from_ex_mem, u_type_immediate_from_ex_mem, alu_src_value,
    load_op_data, rs1_value, rs2_value, rs1_value_from_forwarding_unit, 
    rs2_value_from_forwarding_unit, reg_write_back_data, pc_plus_4_from_if_id, 
    pc_plus_u_type_immediate_from_id_ex, pc_plus_4_from_id_ex, u_type_immediate_from_id_ex,
    sign_ext_from_id_ex, s_type_immediate_from_id_ex, pc_plus_immediate_from_id_ex,
    pc_plus_jal_offset_from_id_ex, load_op_data_from_mem_write_back_reg,
    alu_out_from_mem_write_back_reg, pc_plus_4_from_mem_write_back_reg, 
    u_type_immediate_from_mem_write_back_reg, 
    pc_plus_u_type_immediate_from_mem_write_back_reg;

    wire [4:0] dest_reg_from_ex_mem, dest_reg_from_id_ex, rs1_from_id_ex, rs2_from_id_ex, 
    dest_reg_from_mem_write_back_reg;

    wire [3:0] alu_control, alu_control_from_id_ex;

    wire [2:0] write_back_mux_control_from_control_unit, write_back_mux_control_from_ex_mem,
    write_back_mux_control_from_id_ex, write_back_mux_control_from_mem_write_back_reg;

    wire [1:0] pc_src_control_value, alu_op_control_from_control_unit, pc_src_control, 
    alu_src_control_from_control_unit, alu_src_control_from_id_ex, pc_src_control_from_id_ex;

    wire flush, invert_control_from_alu_control, zero_flag_from_main_alu_instance, func3, 
    reg_write_control_from_control_unit, unsigned_op_from_control_unit, byte_op_from_control_unit, 
    half_op_from_control_unit, mem_read_from_control_unit, mem_read_from_ex_mem, byte_op_from_ex_mem,
    half_op_from_ex_mem, unsigned_op_from_ex_mem, mem_write_from_control_unit, 
    byte_op_from_id_ex, half_op_from_id_ex, reg_write_control_from_id_ex, mem_read_from_id_ex,
    mem_write_from_id_ex, invert_control_from_id_ex, reg_write_control_from_mem_write_back_reg;

    assign flush = pc_src_control_value != 2'b00;
    assign jalr_pc = {alu_out_from_main_alu_instance[31:1], 1'b0};
    assign instruction_address = pc_value;
    assign mem_read = mem_read_from_ex_mem;
    assign mem_address = alu_out_from_ex_mem;
    assign mem_address_request = alu_out_from_main_alu_instance;
    assign mem_data_to_mem = rs2_value_from_forwarding_unit;
    assign mem_write_request = mem_write_from_id_ex;
    assign mem_read_request = mem_read_from_id_ex;
    assign byte_op = byte_op_from_id_ex;
    assign half_op = half_op_from_id_ex;

    adder32 adder32_instance_immediate(
        .in1(pc_value_from_if_id),
        .in2(b_type_immediate_from_sign_ext_instance),
        .out(pc_plus_immediate_value)
    );

    adder32 jal_adder(
        .in1(pc_value_from_if_id),
        .in2(jal_offset_from_sign_ext_instance),
        .out(pc_plus_jal_offset_value)
    );

    pc_src_control pc_src_control_instance(
        .pc_mux_control(pc_src_control_from_id_ex),
        .zero_flag(zero_flag_from_main_alu_instance),
        .pc_control(pc_src_control_value)
    );

    pc pc_instance(
        .clk(clk), 
        .rst(rst), 
        .jump_address(pc_jump_add), 
        .pc_next(pc_value)
    );

    adder32 fetch_adder(
        .in1(32'h4),
        .in2(pc_value),
        .out(pc_plus_4_value)
    );

    mux_4X1 pc_mux(
        .in0(pc_plus_4_value),
        .in1(pc_plus_immediate_from_id_ex),
        .in2(pc_plus_jal_offset_from_id_ex), 
        .in3(jalr_pc), 
        .sel(pc_src_control_value),
        .out(pc_jump_add)
    );

    if_id_reg if_id_reg_instance(
        .clk(clk),
        .rst(rst),
        .en(1'b1),
        .flush(flush),
        .pc_in(pc_value),   
        .inst_in(instruction), 
        .pc_plus_4_in(pc_plus_4_value),
        .pc_out(pc_value_from_if_id),
        .inst_out(instruction_from_if_id),
        .pc_plus_4_out(pc_plus_4_from_if_id)
    );
    
    sign_ext_12_to_32 sign_ext_12_to_32_instance(
        .instruction(instruction_from_if_id), 
        .out(sign_ext_from_sign_ext_instance), 
        .b_type_immediate(b_type_immediate_from_sign_ext_instance),
        .u_type_immediate(u_type_immediate_from_sign_ext_instance),
        .jal_offset(jal_offset_from_sign_ext_instance),
        .s_type_immediate(s_type_immediate_from_sign_ext_instance)
    );

    adder32 u_type_adder(
        .in1(u_type_immediate_from_sign_ext_instance),
        .in2(pc_value_from_if_id),
        .out(pc_plus_u_type_immediate_value)
    );
    
    control_unit control_unit_instance(
        .opcode(instruction_from_if_id[6:0]),
        .func3(instruction_from_if_id[14:12]), 
        .mem_read(mem_read_from_control_unit), 
        .mem_write(mem_write_from_control_unit), 
        .alu_src(alu_src_control_from_control_unit), 
        .reg_write(reg_write_control_from_control_unit),
        .alu_op(alu_op_control_from_control_unit), 
        .mem_to_reg(write_back_mux_control_from_control_unit),
        .pc_src(pc_src_control),
        .byte_op(byte_op_from_control_unit),
        .half_op(half_op_from_control_unit),
        .unsigned_op(unsigned_op_from_control_unit)
    );

    alu_control alu_control_instance(
        .alu_op(alu_op_control_from_control_unit),
        .fun3(instruction_from_if_id[14:12]),
        .fun7(instruction_from_if_id[31:25]),
        .out(alu_control),
        .invert(invert_control_from_alu_control)
    );

    id_ex_reg id_ex_reg_instance(
        .clk(clk),
        .rst(rst),
        .flush(flush),
        .mem_to_reg_control_in(write_back_mux_control_from_control_unit),
        .mem_to_reg_control_out(write_back_mux_control_from_id_ex),
        .reg_write_control_in(reg_write_control_from_control_unit),
        .reg_write_control_out(reg_write_control_from_id_ex),
        .unsigned_op_in(unsigned_op_from_control_unit),
        .unsigned_op_out(unsigned_op_from_id_ex),
        .byte_op_in(byte_op_from_control_unit),
        .byte_op_out(byte_op_from_id_ex),
        .pc_plus_u_type_immediate_value_in(pc_plus_u_type_immediate_value),
        .pc_plus_u_type_immediate_value_out(pc_plus_u_type_immediate_from_id_ex),
        .half_op_in(half_op_from_control_unit),
        .half_op_out(half_op_from_id_ex),
        .dest_reg_in(instruction_from_if_id[11:7]),
        .dest_reg_out(dest_reg_from_id_ex),
        .pc_plus_4_in(pc_plus_4_from_if_id),
        .pc_plus_4_out(pc_plus_4_from_id_ex),
        .u_type_immediate_in(u_type_immediate_from_sign_ext_instance),
        .u_type_immediate_out(u_type_immediate_from_id_ex),
        .mem_read_in(mem_read_from_control_unit),
        .mem_read_out(mem_read_from_id_ex),
        .mem_write_in(mem_write_from_control_unit),
        .mem_write_out(mem_write_from_id_ex),
        .rs1_in(instruction_from_if_id[19:15]),
        .rs1_out(rs1_from_id_ex),
        .rs2_in(instruction_from_if_id[24:20]),
        .rs2_out(rs2_from_id_ex),
        .sign_ext_in(sign_ext_from_sign_ext_instance),
        .sign_ext_out(sign_ext_from_id_ex),
        .s_type_immediate_in(s_type_immediate_from_sign_ext_instance),
        .s_type_immediate_out(s_type_immediate_from_id_ex),
        .alu_src_control_in(alu_src_control_from_control_unit),
        .alu_src_control_out(alu_src_control_from_id_ex),
        .invert_control_in(invert_control_from_alu_control),
        .invert_control_out(invert_control_from_id_ex),
        .alu_control_in(alu_control),
        .alu_control_out(alu_control_from_id_ex),
        .pc_src_control_in(pc_src_control),
        .pc_src_control_out(pc_src_control_from_id_ex),
        .pc_plus_immediate_in(pc_plus_immediate_value),
        .pc_plus_immediate_out(pc_plus_immediate_from_id_ex),
        .pc_plus_jal_offset_in(pc_plus_jal_offset_value),
        .pc_plus_jal_offset_out(pc_plus_jal_offset_from_id_ex)
    );

    reg_file reg_file_instance(
        .clk(clk),
        .rst(rst), 
        .src1_reg(rs1_from_id_ex), 
        .src2_reg(rs2_from_id_ex),
        .src1_reg_value(rs1_value), 
        .src2_reg_value(rs2_value),
        .dest_reg(dest_reg_from_mem_write_back_reg),
        .reg_write_data(reg_write_back_data),
        .reg_write_control(reg_write_control_from_mem_write_back_reg)
    );
    
    mux_4X1 alu_src_mux(
        .in0(rs2_value_from_forwarding_unit),
        .in1(sign_ext_from_id_ex),
        .in2(s_type_immediate_from_id_ex),
        .sel(alu_src_control_from_id_ex),
        .out(alu_src_value)
    ); 
    
    main_alu main_alu_instance(
        .invert(invert_control_from_id_ex),
        .src1(rs1_value_from_forwarding_unit), 
        .src2(alu_src_value),
        .operation(alu_control_from_id_ex),
        .zero_flag(zero_flag_from_main_alu_instance),
        .out(alu_out_from_main_alu_instance)
    );
    
    ex_mem_reg ex_mem_reg_instance(
        .clk(clk),
        .rst(rst),
        .alu_result_in(alu_out_from_main_alu_instance),
        .alu_result_out(alu_out_from_ex_mem),
        .byte_op_in(byte_op_from_id_ex),
        .byte_op_out(byte_op_from_ex_mem),
        .half_op_in(half_op_from_id_ex),
        .half_op_out(half_op_from_ex_mem),
        .unsigned_op_in(unsigned_op_from_id_ex),
        .unsigned_op_out(unsigned_op_from_ex_mem),
        .reg_write_control_in(reg_write_control_from_id_ex),
        .reg_write_control_out(reg_write_control_from_ex_mem),
        .dest_reg_in(dest_reg_from_id_ex),
        .dest_reg_out(dest_reg_from_ex_mem),
        .mem_to_reg_control_in(write_back_mux_control_from_id_ex),
        .mem_to_reg_control_out(write_back_mux_control_from_ex_mem),
        .pc_plus_4_in(pc_plus_4_from_id_ex),
        .pc_plus_4_out(pc_plus_4_from_ex_mem),
        .pc_plus_u_type_immediate_in(pc_plus_u_type_immediate_from_id_ex),
        .pc_plus_u_type_immediate_out(pc_plus_u_type_immediate_from_ex_mem),
        .u_type_immediate_in(u_type_immediate_from_id_ex),
        .u_type_immediate_out(u_type_immediate_from_ex_mem),
        .mem_read_in(mem_read_from_id_ex),
        .mem_read_out(mem_read_from_ex_mem)
    );

    load_op load_op_instance(
        .byte_op(byte_op_from_ex_mem),
        .half_op(half_op_from_ex_mem),
        .unsigned_op(unsigned_op_from_ex_mem),
        .byte_offset(alu_out_from_ex_mem[1:0]),
        .data_from_mem(mem_data_from_mem),
        .op_data(load_op_data)
    );

    mem_write_back_reg mem_write_back_reg_instance(
        .clk(clk),
        .rst(rst),
        .load_op_data_in(load_op_data),
        .load_op_data_out(load_op_data_from_mem_write_back_reg),
        .alu_result_in(alu_out_from_ex_mem),
        .alu_result_out(alu_out_from_mem_write_back_reg),
        .pc_plus_4_in(pc_plus_4_from_ex_mem),
        .pc_plus_4_out(pc_plus_4_from_mem_write_back_reg),
        .u_type_immediate_in(u_type_immediate_from_ex_mem),
        .u_type_immediate_out(u_type_immediate_from_mem_write_back_reg),
        .pc_plus_u_type_immediate_in(pc_plus_u_type_immediate_from_ex_mem),
        .pc_plus_u_type_immediate_out(pc_plus_u_type_immediate_from_mem_write_back_reg),
        .write_back_mux_control_in(write_back_mux_control_from_ex_mem),
        .write_back_mux_control_out(write_back_mux_control_from_mem_write_back_reg),
        .dest_reg_in(dest_reg_from_ex_mem),
        .dest_reg_out(dest_reg_from_mem_write_back_reg),
        .reg_write_control_in(reg_write_control_from_ex_mem),
        .reg_write_control_out(reg_write_control_from_mem_write_back_reg)
    );

    wire [31:0] forwarded_data_from_ex_mem;
    mux_5x1 ex_mem_forward_mux(
        .in0(alu_out_from_ex_mem),
        // .in1(32'h00000000),
        .in2(pc_plus_4_from_ex_mem), 
        .in3(u_type_immediate_from_ex_mem), 
        .in4(pc_plus_u_type_immediate_from_ex_mem),
        .sel(write_back_mux_control_from_ex_mem),
        .out(forwarded_data_from_ex_mem)
    );

    forwarding_unit forwarding_unit_instance(
        .reg_write_control_from_ex_mem(reg_write_control_from_ex_mem),
        .dest_reg_from_ex_mem(dest_reg_from_ex_mem),
        .reg_write_data(forwarded_data_from_ex_mem),
        .rs1(rs1_from_id_ex),
        .rs2(rs2_from_id_ex),
        .rs1_value(rs1_value),
        .rs2_value(rs2_value),
        .forwarded_rs1(rs1_value_from_forwarding_unit),
        .forwarded_rs2(rs2_value_from_forwarding_unit)
    );
    
    mux_5x1 reg_write_mux(
        .in0(alu_out_from_mem_write_back_reg),
        .in1(load_op_data_from_mem_write_back_reg),
        .in2(pc_plus_4_from_mem_write_back_reg), 
        .in3(u_type_immediate_from_mem_write_back_reg), 
        .in4(pc_plus_u_type_immediate_from_mem_write_back_reg),
        .sel(write_back_mux_control_from_mem_write_back_reg),
        .out(reg_write_back_data)
    );
           
endmodule


