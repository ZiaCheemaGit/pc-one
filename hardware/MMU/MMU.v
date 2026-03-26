`timescale 1ns / 1ps

module MMU(
    input uart_busy,
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
    output [17:0] vram_addr // valid from 0 to 153,599 
);

    wire is_rom = (addr < 32'h00002000);
    wire is_ram = (addr >= 32'h00002000) && (addr <= 32'h00003FFF);
    wire is_uart_data = (addr == 32'h00004000);
    wire is_uart_status = (addr == 32'h00004004);
    wire is_vram = (addr >= 32'h00004008) && (addr <= 32'h00007C2F);

    wire rom_read = mem_read_cpu && is_rom;
    assign ram_read = mem_read_cpu && is_ram;
    assign ram_write = mem_write_cpu && is_ram;
    assign vram_read = mem_read_cpu && is_vram;
    assign vram_write = mem_write_cpu && is_vram;

    wire uart_read = mem_read_cpu && is_uart_status;
    assign uart_write = mem_write_cpu && is_uart_data && !uart_busy;

    assign vram_addr = addr - 32'h00004008;

    reg [31:0] data_to_cpu_r;
    assign data_to_cpu = data_to_cpu_r;

    always @(*) begin
        data_to_cpu_r = 32'b0;

        if (ram_read) begin
            data_to_cpu_r = data_from_ram;
        end else if (uart_read) begin
            data_to_cpu_r = {31'b0, uart_busy};
        end else if (rom_read) begin
            data_to_cpu_r = data_from_rom;
        end else if (vram_read) begin
            data_to_cpu_r = {30'b0, data_from_vram};
        end
    end

endmodule

