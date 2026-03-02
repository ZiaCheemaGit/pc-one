`timescale 1ns/1ps

module top_nexys3(
    input  clk_from_FPGA,
    input  rst_from_FPGA,
    output rst_on,
    output uart_tx_pin_for_FPGA,
    output vga_red_for_FPGA, 
    output vga_green_for_FPGA,
    output vga_blue_for_FPGA,
    output vsync_for_FPGA,
    output hsync_for_FPGA
);

    assign rst_on = rst_from_FPGA;

    reg clk_MHz = 0;
    reg clk_25MHz = 0;
    reg [5:0] counter = 0;

    parameter counter_1MHz = 49;
    parameter counter_2MHz = 24;
    parameter counter_5MHz = 9;
    parameter counter_10MHz = 4;
    parameter counter_25MHz = 1;

    always @(posedge clk_from_FPGA) begin
        if (counter == counter_25MHz) begin
            counter <= 0;
            clk_MHz <= ~clk_MHz;
        end else begin
            counter <= counter + 1;
        end
    end

    always @(posedge clk_from_FPGA) begin
        if (counter == counter_25MHz) begin
            counter <= 0;
            clk_25MHz <= ~clk_25MHz;
        end else begin
            counter <= counter + 1;
        end
    end

    pc_one pc_one_instance(
        .clk_from_FPGA(clk_MHz),
        .clk_25MHz(clk_25MHz),
        .rst_from_FPGA(rst_from_FPGA),
        .uart_tx_pin_for_FPGA(uart_tx_pin_for_FPGA),
        .vga_red_for_FPGA(vga_red_for_FPGA), 
        .vga_green_for_FPGA(vga_green_for_FPGA),
        .vga_blue_for_FPGA(vga_blue_for_FPGA),
        .vsync_for_FPGA(vsync_for_FPGA),
        .hsync_for_FPGA(hsync_for_FPGA)
    );

endmodule


