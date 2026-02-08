`timescale 1ns / 1ps

module top_nexys3(
    input  wire clk_100MHz,
    input  wire rst,
    output wire rst_on,
    output wire uart_tx
);

    assign rst_on = rst;

    

endmodule
