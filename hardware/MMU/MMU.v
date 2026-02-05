module MMU(
    input uart_busy,
    input  [31:0] addr, 
    input  [31:0] data_from_ram, 
    input  [31:0] data_from_cpu,  
    input         mem_read_cpu,
    input         mem_write_cpu,
    output        ram_read,
    output        ram_write,
    output [31:0] data_to_ram,
    output [31:0] data_to_cpu,
    output        uart_write
);

    wire is_ram = (addr >= 32'h00000000) && (addr <= 32'h00003FFF);
    wire is_uart_data   = (addr == 32'h00004000);
    wire is_uart_status = (addr == 32'h00004004);

    assign ram_read   = mem_read_cpu  && is_ram;
    assign ram_write  = mem_write_cpu && is_ram;
    assign data_to_ram = data_from_cpu;

    wire uart_read;
    assign uart_read = mem_read_cpu && is_uart_status;
    assign uart_write = mem_write_cpu && is_uart_data;

    reg [31:0] data_to_cpu_r;
    assign data_to_cpu = data_to_cpu_r;

    always @(*) begin
        data_to_cpu_r = 32'b0;

        if (mem_read_cpu) begin
            if (ram_read) begin
                data_to_cpu_r = data_from_ram;
            end
            else if (uart_read) begin
                data_to_cpu_r = {31'b0, uart_busy};
            end
        end
    end

endmodule

