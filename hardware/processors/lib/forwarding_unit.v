`timescale 1ns / 1ps

module forwarding_unit(
    input wire reg_write_control_from_ex_mem,
    input wire [4:0] dest_reg_from_ex_mem,
    input wire [31:0] reg_write_data,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [31:0] rs1_value,
    input wire [31:0] rs2_value,
    output wire [31:0] forwarded_rs1,
    output wire [31:0] forwarded_rs2
);

    wire forward_rs1 = reg_write_control_from_ex_mem && 
                    (dest_reg_from_ex_mem != 5'b0) && 
                    (dest_reg_from_ex_mem == rs1);

    assign forwarded_rs1 = forward_rs1 ? reg_write_data : rs1_value;

    wire forward_rs2 = reg_write_control_from_ex_mem && 
                    (dest_reg_from_ex_mem != 5'b0) && 
                    (dest_reg_from_ex_mem == rs2);

    assign forwarded_rs2 = forward_rs2 ? reg_write_data : rs2_value;

endmodule
