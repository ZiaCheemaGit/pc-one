/*


*/

`timescale 1ns / 1ps

module top(
    input clk,
    input rst
    );
    
    wire [31:0] data_in_cpu, data_out_cpu, mem_add, instr_add, instruction;
    wire mem_read, mem_write;

    core core_instance(
        .clk(clk),
        .rst(rst),
        .instruction_address(instr_add),
        .instruction(instruction),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_address(mem_add),
        .mem_data_from_mem(data_in_cpu),
        .mem_data_to_mem(data_out_cpu)
    );
    
    ram_16KB ram_16KB_instance(
        .clk(clk),
        .pc_address(instr_add),
        .instruction(instruction),
        .data_address(mem_add),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .data_in(data_out_cpu),
        .data_out(data_in_cpu)
    );
    
endmodule


