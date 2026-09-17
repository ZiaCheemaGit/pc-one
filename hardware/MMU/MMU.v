`timescale 1ns / 1ps

module MMU(
    input clk,
    input uart_tx_busy,
    input uart_rx_valid,
    input [31:0] uart_rx_data,
    input  [31:0] addr, 
    input  [31:0] data_from_rom, 
    input  [31:0] data_from_ram, 
    input  [1:0] data_from_vram,  
    input         mem_read_cpu,
    input         mem_read,
    input         mem_write_cpu,
    output        ram_write,
    output        vram_write,
    output wire [31:0] data_to_cpu,
    output        uart_read,
    output        uart_write,
    output [31:0] mem_add_ram,
    output [17:0] vram_addr // valid from 0 to 153,599 
);

    parameter BOOT_ROM_BASE = 32'h0;
    parameter BOOT_ROM_LENGTH = 32'h2000;
    parameter BOOT_ROM_END = BOOT_ROM_BASE + BOOT_ROM_LENGTH;

    parameter RAM_BASE = 32'h2000;
    parameter RAM_LENGTH = 32'h2000;
    parameter RAM_END = RAM_BASE + RAM_LENGTH;

    parameter UART_DATA_REG = 32'h4000;

    parameter UART_STATUS_REG = 32'h4004;

    parameter VRAM_BASE = 32'h4008;
    parameter VRAM_END = 32'h29808;

    assign mem_add_ram = addr - RAM_BASE;
    assign vram_addr = addr - VRAM_BASE; 

    wire is_boot_rom = (addr >= BOOT_ROM_BASE) && (addr < BOOT_ROM_END );
    wire is_ram = (addr >= RAM_BASE) && (addr < RAM_END);
    wire is_uart_data = (addr == UART_DATA_REG);
    wire is_uart_tx_status = (addr == UART_STATUS_REG);
    wire is_vram = (addr >= VRAM_BASE) && (addr < VRAM_END);

    wire boot_rom_read = mem_read_cpu && is_boot_rom;
    assign ram_read = mem_read && is_ram;
    assign ram_write = mem_write_cpu && is_ram;
    wire vram_read = mem_read_cpu && is_vram;
    assign vram_write = mem_write_cpu && is_vram;

    wire uart_tx_status_read = mem_read_cpu && is_uart_tx_status;
    assign uart_write = mem_write_cpu && is_uart_data && !uart_tx_busy;
    assign uart_read = mem_read_cpu && is_uart_data && uart_rx_valid;

    assign data_to_cpu = (uart_tx_status_read) ? {31'b0, uart_tx_busy} :
                        (uart_read) ? uart_rx_data :
                        //(boot_rom_read) ? data_from_rom :
                        (vram_read) ? {30'b0, data_from_vram} :
                        (mem_read) ? data_from_ram : 
                        32'b0;

endmodule
