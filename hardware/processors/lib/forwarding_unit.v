`timescale 1ns / 1ps

module forwarding_unit(
    input wire reg_write_control_from_ex_mem,
    input wire [4:0] dest_reg_from_ex_mem,
    input wire [31:0] reg_write_back_data_from_ex_mem,
    input wire [4:0] rs1_from_id_ex,
    input wire [4:0] rs2_from_id_ex,
    input wire [31:0] rs1_value,
    input wire [31:0] rs2_value,
    output wire [31:0] forwarded_rs1,
    output wire [31:0] forwarded_rs2,
    input wire [4:0] rs1_from_ex_mem,
    input wire [4:0] rs2_from_ex_mem,
    input wire reg_write_control_from_mem_write_back,
    input wire [4:0] dest_reg_from_mem_write_back,
    input wire [31:0] reg_write_back_data
);

    wire forward_rs1_from_ex_mem = reg_write_control_from_ex_mem && 
                                (dest_reg_from_ex_mem != 5'b0) && 
                                (dest_reg_from_ex_mem == rs1_from_id_ex);

    wire forward_rs1_from_write_back = reg_write_control_from_mem_write_back &&
                                    (dest_reg_from_mem_write_back != 5'b0) &&
                                    (dest_reg_from_mem_write_back == rs1_from_ex_mem);

    assign forwarded_rs1 = forward_rs1_from_ex_mem ? reg_write_back_data_from_ex_mem :
                            forward_rs1_from_write_back ? reg_write_back_data : rs1_value;

    wire forward_rs2_from_ex_mem = reg_write_control_from_ex_mem && 
                                    (dest_reg_from_ex_mem != 5'b0) && 
                                    (dest_reg_from_ex_mem == rs2_from_id_ex);
    
    wire forward_rs2_from_write_back = reg_write_control_from_mem_write_back &&
                                    (dest_reg_from_mem_write_back != 5'b0) &&
                                    (dest_reg_from_mem_write_back == rs2_from_ex_mem);

    assign forwarded_rs2 = forward_rs2_from_ex_mem ? reg_write_back_data_from_ex_mem : 
                            forward_rs2_from_write_back ? reg_write_back_data : rs2_value;

endmodule
