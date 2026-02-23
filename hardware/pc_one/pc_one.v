/*

This is the top level module for this project
Its inputs/outputs are connected directly to FPGA ports

MMU
ROM = 0x00000000 --> 0x00001FFF
RAM = 0x00002000 --> 0x00003FFF
UART =  00004000
UART_STATUS = 0x00004004

*/

`timescale 1ns / 1ps

module pc_one(
    input clk_from_FPGA,
    input clk_25MHz,
    input rst_from_FPGA,
    output uart_tx_pin_for_FPGA,
    output vga_red_for_FPGA, 
    output vga_green_for_FPGA,
    output vga_blue_for_FPGA,
    output vsync_for_FPGA,
    output hsync_for_FPGA
    );
    
    wire [31:0] mem_add, instr_add, instruction, ram_data_to_mmu, 
    cpu_data_to_mmu, mmu_data_to_cpu, mmu_data_to_ram, rom_data_to_mmu;

    wire mem_read, mem_write, mmu_mem_read, mmu_mem_write, uart_write_en, 
    uart_busy;
    
    MMU MMU_instance(
        .uart_busy(uart_busy),
        .addr(mem_add),
        .data_from_rom(rom_data_to_mmu),
        .data_from_ram(ram_data_to_mmu),
        .data_from_cpu(cpu_data_to_mmu),
        .mem_read_cpu(mem_read),
        .mem_write_cpu(mem_write),
        .ram_read(mmu_mem_read),
        .ram_write(mmu_mem_write),
        .data_to_ram(mmu_data_to_ram),
        .data_to_cpu(mmu_data_to_cpu),
        .uart_write(uart_write_en)
    );

    core core_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .instruction_address(instr_add),
        .instruction(instruction),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_address(mem_add),
        .mem_data_from_mem(mmu_data_to_cpu),
        .mem_data_to_mem(cpu_data_to_mmu)
    );
    
    ram ram_instance(
        .clk(clk_from_FPGA),
        .data_address(mem_add),
        .mem_read(mmu_mem_read),
        .mem_write(mmu_mem_write),
        .data_in(mmu_data_to_ram),
        .data_out(ram_data_to_mmu)
    );

    rom rom_instance(
        .pc(instr_add),       
        .instruction(instruction),
        .addr(mem_add),
        .data(rom_data_to_mmu)
    );

    uart_tx uart_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .write_en(uart_write_en),
        .data(cpu_data_to_mmu[7:0]),
        .tx(uart_tx_pin_for_FPGA),
        .uart_busy(uart_busy)
    );

    vga_controller vga_controller_instance(
        .clk_25MHz(clk_25MHz),     
        .reset(rst_from_FPGA),
        .pixel_data(7),  // From VRAM
        .red(vga_red_for_FPGA),         
        .green(vga_green_for_FPGA),       
        .blue(vga_blue_for_FPGA),         
        .hsync(hsync_for_FPGA),
        .vsync(vsync_for_FPGA),
        .mem_address()  // To VRAM
    );
    
endmodule


