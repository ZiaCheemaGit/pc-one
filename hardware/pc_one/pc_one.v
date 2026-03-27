`timescale 1ns / 1ps

/*

This is the top level module for this project
Its inputs/outputs are connected directly to FPGA ports

MMU
ROM = 0x00000000 --> 0x00001FFF
RAM = 0x00002000 --> 0x00003FFF
UART =  00004000
UART_STATUS = 0x00004004

*/


module pc_one(
    input clk_from_FPGA,
    input clk_25MHz,
    input rst_from_FPGA,
    input uart_rx_pin_from_FPGA,
    output uart_tx_pin_for_FPGA,
    output vga_red_for_FPGA, 
    output vga_green_for_FPGA,
    output vga_blue_for_FPGA,
    output vsync_for_FPGA,
    output hsync_for_FPGA
    );
    
    wire [31:0] mem_add, instr_add, instruction, ram_data_to_mmu, data_from_cpu,
    mmu_data_to_cpu, rom_data_to_mmu;
    
    wire [1:0] data_from_vram;

    wire mem_read, mem_write, mmu_mem_read, mmu_mem_write, uart_write_en, 
    uart_tx_busy, uart_rx_busy, byte_op , half_op, unsigned_op, vram_write;
    
    wire [17:0] vram_add;
    wire [7:0] uart_rx_data;
    MMU MMU_instance(
        .uart_tx_busy(uart_tx_busy),
        .uart_rx_data(uart_rx_data),
        .uart_rx_busy(uart_rx_busy),
        .addr(mem_add),
        .data_from_rom(rom_data_to_mmu),
        .data_from_ram(ram_data_to_mmu),
        .mem_read_cpu(mem_read),
        .mem_write_cpu(mem_write),
        .ram_read(mmu_mem_read),
        .ram_write(mmu_mem_write),
        .data_to_cpu(mmu_data_to_cpu),
        .uart_write(uart_write_en),
        .vram_write(vram_write),
        .data_from_vram(data_from_vram),
        .vram_addr(vram_add)
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
        .mem_data_to_mem(data_from_cpu),
        .byte_op(byte_op),
        .half_op(half_op),
        .unsigned_op(unsigned_op)
    );
    
    ram ram_instance(
        .clk(clk_from_FPGA),
        .data_address(mem_add),
        .mem_read(mmu_mem_read),
        .mem_write(mmu_mem_write),
        .byte_op(byte_op),
        .half_op(half_op),
        .unsigned_op(unsigned_op),
        .data_in(data_from_cpu),
        .data_out(ram_data_to_mmu)
    );

    rom rom_instance(
        .pc(instr_add),       
        .instruction(instruction),
        .byte_op(byte_op),
        .half_op(half_op),
        .addr(mem_add),
        .data(rom_data_to_mmu)
    );

    uart_tx uart_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .write_en(uart_write_en),
        .data(data_from_cpu[7:0]),
        .tx(uart_tx_pin_for_FPGA),
        .uart_busy(uart_tx_busy)
    );

    uart_rx uart_rx_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .rx(uart_rx_pin_from_FPGA),
        .data(uart_rx_data),
        .busy(uart_rx_busy)
    );

    wire [17:0] vga_addr;
    wire [1:0] vga_data;
    vga_controller vga_inst (
        .clk_25MHz(clk_25MHz),
        .reset(rst_from_FPGA),
        .pixel_data(vga_data),
        .red(vga_red_for_FPGA),
        .green(vga_green_for_FPGA),
        .blue(vga_blue_for_FPGA),
        .hsync(hsync_for_FPGA),
        .vsync(vsync_for_FPGA),
        .mem_address(vga_addr)
    );

    vram vram_inst (
        .clk_vga(clk_25MHz),
        .clk_cpu(clk_from_FPGA),        
        .addr_vga(vga_addr),
        .data_vga(vga_data),
        .we_cpu(vram_write),         
        .addr_cpu(vram_add),       
        .data_cpu(data_from_cpu[1:0]),        
        .data_cpu_out()          
    );
    
endmodule


