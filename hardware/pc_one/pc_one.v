`timescale 1ns / 1ps

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
    
    parameter RAM_BASE = 32'h2000;

    wire [31:0] mem_address, mem_address_request, mem_add_ram, instr_add, instruction, ram_data_to_mmu, data_from_cpu,
    mmu_data_to_cpu, rom_data_to_mmu, uart_rx_data;
    
    wire [1:0] data_from_vram;

    wire mem_read, mem_read_request, mem_write_request, uart_write_en, uart_read,
    uart_tx_busy, rx_valid, byte_op , half_op, vram_write;
    
    wire [17:0] vram_add;
    MMU MMU_instance(
        .clk(clk_from_FPGA),
        .uart_tx_busy(uart_tx_busy),
        .uart_rx_data(uart_rx_data),
        .uart_write(uart_write_en),
        .uart_read(uart_read),
        .uart_rx_valid(rx_valid),
        .addr(mem_address),
        .addr_request(mem_address_request),
        .mem_write_request(mem_write_request),
        .mem_read(mem_read),
        .data_from_rom(rom_data_to_mmu),
        .data_from_ram(ram_data_to_mmu),
        .data_to_cpu(mmu_data_to_cpu),
        .vram_write(vram_write),
        .data_from_vram(data_from_vram),
        .vram_addr(vram_add)
    );
    
    core core_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .instruction_address(instr_add),
        .instruction(instruction),
        .mem_write_request(mem_write_request),
        .mem_read_request(mem_read_request),
        .mem_address_request(mem_address_request),
        .mem_address(mem_address),
        .mem_read(mem_read),
        .mem_data_from_mem(mmu_data_to_cpu),
        .mem_data_to_mem(data_from_cpu),
        .byte_op(byte_op),
        .half_op(half_op)
    );
    
    ram ram_instance(
        .clk(clk_from_FPGA),
        .data_address(mem_address_request - RAM_BASE),
        .mem_read(mem_read_request),
        .mem_write(mem_write_request),
        .byte_op(byte_op),
        .half_op(half_op),
        .data_in(data_from_cpu),
        .data_out(ram_data_to_mmu)
    );

    boot_rom boot_rom_instance(
        .clk(clk_from_FPGA),
        .pc(instr_add),       
        .instruction(instruction),
        .addr(mem_address_request),
        .data(rom_data_to_mmu)
    );

    uart_tx uart_tx_instance(
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .write_en(uart_write_en),
        .data(data_from_cpu[7:0]),
        .tx(uart_tx_pin_for_FPGA),
        .uart_busy(uart_tx_busy)
    );

    uart_rx uart_rx_inst (
        .clk(clk_from_FPGA),
        .rst(rst_from_FPGA),
        .rx(uart_rx_pin_from_FPGA),
        .data(uart_rx_data),
        .data_valid(rx_valid),
        .uart_read(uart_read)
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
        .data_cpu(data_from_cpu[1:0])       
        //.data_cpu_out()          
    );
    
endmodule


