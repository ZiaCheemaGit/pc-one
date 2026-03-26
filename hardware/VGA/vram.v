module vram (
    input clk_vga,
    input clk_cpu,

    input [17:0] addr_vga,
    output reg [1:0] data_vga,

    input we_cpu,
    input [17:0] addr_cpu,
    input [1:0] data_cpu,
    output reg [1:0] data_cpu_out
);

	reg [1:0] mem [0:153599];
	initial begin
		$readmemh("vram_init.hex", mem);
	end

	always @(posedge clk_vga)
		data_vga <= mem[addr_vga];

	always @(posedge clk_cpu)
	begin
		if (we_cpu)
			mem[addr_cpu] <= data_cpu;

		data_cpu_out <= mem[addr_cpu];
	end

endmodule

