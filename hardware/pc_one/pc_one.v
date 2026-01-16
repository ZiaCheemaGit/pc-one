/*


*/

`timescale 1ns / 1ps

module pc_one(
    input clk_from_FPGA,
    input rst_from_FPGA,
    output uart_tx_pin_for_FPGA
    );
    
    wire [31:0] data_in_cpu, data_out_cpu, mem_add, instr_add, instruction;
    wire mem_read, mem_write, mmu_mem_read, mmu_mem_write, uart_write_en;
    wire uart_busy;
    
    MMU MMU_instance(
        .addr(mem_add),
        .mem_read_cpu(mem_read),
        .mem_write_cpu(mem_write),
        .ram_read(mmu_mem_read),
        .ram_write(mmu_mem_write),
        .uart_write(uart_write_en),
        .uart_status_read(uart_busy)
    );

    core core_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .instruction_address(instr_add),
        .instruction(instruction),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_address(mem_add),
        .mem_data_from_mem(data_in_cpu),
        .mem_data_to_mem(data_out_cpu)
    );
    
    ram_16KB ram_16KB_instance(
        .clk(clk_from_FPGA),
        .pc_address(instr_add),
        .instruction(instruction),
        .data_address(mem_add),
        .mem_read(mmu_mem_read),
        .mem_write(mmu_mem_write),
        .data_in(data_out_cpu),
        .data_out(data_in_cpu)
    );

    uart_tx uart_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .write_en(uart_write_en),
        .data(data_out_cpu[7:0]),
        .tx(uart_tx_pin_for_FPGA),
        .uart_busy(uart_busy)
    );
    
endmodule


