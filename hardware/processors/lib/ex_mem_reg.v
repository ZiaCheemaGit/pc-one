`timescale 1ns / 1ps

module ex_mem_reg(
    input wire mem_write_in,
    input wire mem_read_in,
    input wire byte_op_in,
    input wire half_op_in,
    input wire unsigned_op_in,
    output wire mem_write_out,
    output wire mem_read_out,
    output wire byte_op_out,
    output wire half_op_out,
    output wire unsigned_op_out
);

    assign mem_write_out = mem_write_in;
    assign mem_read_out = mem_read_in;
    assign byte_op_out = byte_op_in;
    assign half_op_out = half_op_in;
    assign unsigned_op_out = unsigned_op_in;

endmodule
