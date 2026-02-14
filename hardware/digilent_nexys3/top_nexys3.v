`timescale 1ns/1ps

module top_nexys3(
    input  wire clk_from_FPGA,
    input  wire rst_from_FPGA,
    output wire rst_on,
    output wire uart_tx_pin_for_FPGA
);

    assign rst_on = rst_from_FPGA;

    reg clk_1MHz = 0;
    reg [5:0] counter = 0;

    always @(posedge clk_from_FPGA) begin
        if (counter == 49) begin
            counter <= 0;
            clk_1MHz <= ~clk_1MHz;
        end else begin
            counter <= counter + 1;
        end
    end

    pc_one pc_one_instance(
        .clk_from_FPGA(clk_1MHz),
        .rst_from_FPGA(rst_from_FPGA),
        .uart_tx_pin_for_FPGA(uart_tx_pin_for_FPGA)
    );

endmodule


