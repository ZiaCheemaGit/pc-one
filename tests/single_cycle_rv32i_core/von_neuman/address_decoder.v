module address_decoder(
    input [31:0] cpu_write_address,
    input mem_read_cpu_control,
    input mem_write_cpu_control,
    output mem_write, 
    output mem_read, 
    output uart_write
);

    wire is_mem  = (cpu_write_address < 32'h00004000);
    wire is_uart = (cpu_write_address >= 32'h00004000) && (cpu_write_address <  32'h00004001);
    

    assign uart_write = mem_write_cpu_control && is_uart;
    assign mem_write  = mem_write_cpu_control && is_mem;
    assign mem_read   = mem_read_cpu_control  && is_mem;

endmodule

