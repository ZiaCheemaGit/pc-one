/*


*/

`timescale 1ns / 1ps

module top(
    input clk,
    input rst,
    output uart_tx
    );
    
    wire [31:0] data_in_cpu, data_out_cpu, mem_add, instr_add, instruction;
    wire mem_read, mem_write, address_decoder_mem_read, address_decoder_mem_write, uart_write_en;
    
    address_decoder address_decoder_instance(
        .cpu_write_address(mem_add),
        .mem_read_cpu_control(mem_read),
        .mem_write_cpu_control(mem_write),
        .mem_read(address_decoder_mem_read), 
        .mem_write(address_decoder_mem_write), 
        .uart_write(uart_write_en)
    );

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
        .mem_read(address_decoder_mem_read),
        .mem_write(address_decoder_mem_write),
        .data_in(data_out_cpu),
        .data_out(data_in_cpu)
    );

    uart_tx uart_instance(
        .clk(clk),
        .reset(rst),
        .write_en(uart_write_en),
        .data(data_out_cpu[7:0]),
        .tx(uart_tx)
    );
    
endmodule


