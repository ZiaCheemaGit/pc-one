/**

single cycle rv32i core

pc_mux inputs 
for jalr pc = (rs1 + sign_extend(instruction[31:20])) << 1
for jal pc = pc + offset sign_extend(instruction[31:12])

remaining parts 
alu control unit internal working
pc_mux sel control 
reg_write_mux

**/

module single_cycle_rv32i_core(
    input clk,
    input rst,
    output [31:0] instruction_address,
    input [31:0] instruction,
    output mem_write,
    output mem_read,
    output [31:0] mem_address,
    input [31:0] mem_data_from_mem,
    output [31:0] mem_data_to_mem
    );
    
    wire [31:0] pc_in_add, pc_out_add;
    pc pc_instance(
        .clk(clk), 
        .rst(rst), 
        .jump_address(pc_in_add), 
        .pc_next(pc_out_add)
    );
    assign instruction_address = pc_out_add;
     
    wire [31:0] sign_ext_out_shifted;
    wire [31:0] sign_ext_out;
    
    wire [31:0] u_type_immediate, jal_offset;
    sign_ext_12_to_32 sign_ext_12_to_32_instance(
        .instruction(instruction), 
        .out(sign_ext_out), 
        .u_type_immediate(u_type_immediate),
        .jal_offset(jal_offset)
    );
    
    shift_left_1 shift_left_1_instance(
        .in(sign_ext_out),
        .out(sign_ext_out_shifted)
    );
    
    wire branch_control, mem_read_control, mem_write_control, alu_src_control, reg_write_control;
    wire [1:0] alu_op_control;
    wire [2:0] mem_to_reg_control;
    control_unit control_unit_instance(
        .opcode(instruction[6:0]),
        .branch(branch_control), 
        .mem_read(mem_read), 
        .mem_write(mem_write), 
        .alu_src(alu_src_control), 
        .reg_write(reg_write_control),
        .alu_op(alu_op_control), 
        .mem_to_reg(mem_to_reg_control)
    );
    
    wire [3:0] alu_control_unit;
    alu_control alu_control_instance(
        .alu_op(alu_op_control),
        .fun3(instruction[31:25]),
        .fun7(instruction[14:12]),
        .out(alu_control_unit)
    );
    
    wire [31:0] rs1, rs2, reg_write_data;
    reg_file reg_file_instance(
            .clk(clk),
            .dest_reg(instruction[11:7]), 
            .src1_reg(instruction[19:15]), 
            .src2_reg(instruction[24:20]),
            .reg_write_data(reg_write_data),
            .reg_write_control(reg_write_control),
            .src1_reg_value(rs1), 
            .src2_reg_value(rs2)
        );
    assign mem_data_to_mem = rs2;
    
    wire [31:0] alu_src_value;
    mux_2X1 alu_src_mux(
        .in0(rs2),
        .in1(sign_ext_out),
        .sel(alu_src_control),
        .out(alu_src_value)
    ); 
    
    wire [31:0] alu_out;
    main_alu main_alu_instance(
        .src1(rs1), 
        .src2(alu_src_value),
        .operation(alu_control_unit),
        .zero_flag(),
        .out(alu_out)
    );
    assign mem_address = alu_out;
    
    wire [31:0] pc_plus_4;
    adder32 adder32_instance_const4(
            .in1(4),
            .in2(pc_out_add),
            .out(pc_plus_4)
    );
    
    wire [31:0] pc_plus_immediate_out;
    adder32 adder32_instance_immediate(
             .in1(pc_out_add),
             .in2(sign_ext_out_shifted),
             .out(pc_plus_immediate_out)
    );
         
    wire [31:0] jal_pc;
    adder32 jal_adder(
        .in1(pc_out_add),
        .in2(jal_offset),
        .out(jal_pc)
    );
    
    wire [31:0] jalr_pc;
    shift_left_1 jalr_pc_shift(
        .in(alu_out),
        .out(jalr_pc)
    );
    
    mux_4X1 pc_mux(
        .in0(pc_plus_4),
        .in1(pc_plus_immediate_out),
        .in2(jal_pc), 
        .in3(jalr_pc), 
        .sel(),
        .out(pc_in_add)
    );
    
    wire [31:0] pc_plus_u_type_immediate;
    adder32 u_type_adder(
        .in1(u_type_immediate),
        .in2(pc_out_add),
        .out(pc_plus_u_type_immediate)
    );
       
    mux_5x1 reg_write_mux(
        .in0(alu_out),
        .in1(mem_data_from_mem),
        .in2(pc_plus_4), 
        .in3(u_type_immediate), 
        .in4(pc_plus_u_type_immediate),
        .sel(mem_to_reg_control),
        .out(reg_write_data)
    );
           
endmodule
