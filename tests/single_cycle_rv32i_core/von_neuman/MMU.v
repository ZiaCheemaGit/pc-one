module MMU(
    input  [31:0] addr,
    input         mem_read_cpu,
    input         mem_write_cpu,
    output        ram_read,
    output        ram_write,
    output        uart_write,
    output        uart_status_read
);

    wire is_ram   = (addr < 32'h00004000);
    wire is_uart_data   = (addr == 32'h00004000);
    wire is_uart_status = (addr == 32'h00004004);

    assign ram_read   = mem_read_cpu  && is_ram;
    assign ram_write  = mem_write_cpu && is_ram;

    assign uart_write = mem_write_cpu && is_uart_data;
    assign uart_status_read = mem_read_cpu && is_uart_status;

endmodule

