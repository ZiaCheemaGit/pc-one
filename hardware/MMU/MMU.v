`timescale 1ns / 1ps

module MMU(
    input uart_tx_busy,
    input uart_rx_busy,
    input [7:0] uart_rx_data,
    input  [31:0] addr, 
    input  [31:0] data_from_rom, 
    input  [31:0] data_from_ram, 
    input  [1:0] data_from_vram,  
    input         mem_read_cpu,
    input         mem_write_cpu,
    output        ram_read,
    output        ram_write,
    output        vram_write,
    output [31:0] data_to_cpu,
    output        uart_write,
    output        uart_read,
    output [17:0] vram_addr // valid from 0 to 153,599 
);

    wire is_rom = (addr < 32'h00002000);
    wire is_ram = (addr >= 32'h00002000) && (addr <= 32'h00003FFF);
    wire is_uart_data = (addr == 32'h00004000);
    wire is_uart_tx_status = (addr == 32'h00004004);
    wire is_uart_rx_status = (addr == 32'h00004008);
    wire is_vram = (addr >= 32'h0000400C) && (addr <= 32'h00007C33);

    wire rom_read = mem_read_cpu && is_rom;
    assign ram_read = mem_read_cpu && is_ram;
    assign ram_write = mem_write_cpu && is_ram;
    assign vram_read = mem_read_cpu && is_vram;
    assign vram_write = mem_write_cpu && is_vram;

    wire uart_tx_status_read = mem_read_cpu && is_uart_tx_status;
    wire uart_rx_status_read = mem_read_cpu && is_uart_rx_status;
    assign uart_write = mem_write_cpu && is_uart_data && !uart_tx_busy;
    assign uart_read = mem_read_cpu && is_uart_data && !uart_rx_busy;

    assign vram_addr = addr - 32'h0000400C;

    reg [31:0] data_to_cpu_r;
    assign data_to_cpu = data_to_cpu_r;

    always @(*) begin
        data_to_cpu_r = 32'b0;

        if (ram_read) begin
            data_to_cpu_r = data_from_ram;
        end else if (uart_tx_status_read) begin
            data_to_cpu_r = {31'b0, uart_tx_busy};
        end else if (uart_rx_status_read) begin
            data_to_cpu_r = {31'b0, uart_rx_busy};
        end else if (uart_read) begin
            data_to_cpu_r = {24'b0, uart_rx_data};
        end else if (rom_read) begin
            data_to_cpu_r = data_from_rom;
        end else if (vram_read) begin
            data_to_cpu_r = {30'b0, data_from_vram};
        end
    end

endmodule

