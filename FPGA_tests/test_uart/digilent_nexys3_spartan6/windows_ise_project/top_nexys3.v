`timescale 1ns / 1ps

module top_nexys3(
    input  wire clk_100MHz,
    input  wire rst,
    output wire rst_on,
    output wire uart_tx
);

    assign rst_on = rst;

    pc_one pc_one_instance(
		 .clk_from_FPGA_100MHz(clk_100MHz),
		 .rst_from_FPGA(rst),
		 .uart_tx_pin_for_FPGA(uart_tx)
    );
    

endmodule
