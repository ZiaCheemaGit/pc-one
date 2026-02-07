`timescale 1ns / 1ps

module top_nexys3(
    input  wire clk_100MHz,
    input  wire rst,
    output wire rst_on,
    output wire uart_tx
);

    assign rst_on = rst;

    reg  [7:0] uart_data;
    reg        write_en;
    wire       uart_busy;

    uart_tx uart_instance (
        .clk(clk_100MHz),
        .rst(rst),
        .write_en(write_en),
        .data(uart_data),
        .tx(uart_tx),
        .uart_busy(uart_busy)
    );

    reg [4:0] msg_idx;
    reg       sent_this_idle;   // ? KEY FIX

    // --------------------------------------------------
    // Message ROM
    // --------------------------------------------------
    function [7:0] msg_rom(input [4:0] idx);
        case (idx)
            0:  msg_rom = "H";
            1:  msg_rom = "e";
            2:  msg_rom = "l";
            3:  msg_rom = "l";
            4:  msg_rom = "o";
            5:  msg_rom = " ";
            6:  msg_rom = "f";
            7:  msg_rom = "r";
            8:  msg_rom = "o";
            9:  msg_rom = "m";
            10: msg_rom = " ";
            11: msg_rom = "U";
            12: msg_rom = "A";
            13: msg_rom = "R";
            14: msg_rom = "T";
            15: msg_rom = "!";
				16: msg_rom = 8'h0D;
            17: msg_rom = 8'h0A;
            default: msg_rom = 8'h00;
        endcase
    endfunction

    // --------------------------------------------------
    // Control logic
    // --------------------------------------------------
    always @(posedge clk_100MHz) begin
        if (rst) begin
            msg_idx         <= 0;
            uart_data       <= 8'h00;
            write_en        <= 1'b0;
            sent_this_idle  <= 1'b0;
        end else begin
            write_en <= 1'b0;

            if (uart_busy) begin
                // UART is busy ? reset idle flag
                sent_this_idle <= 1'b0;
            end else if (!sent_this_idle) begin
                // UART just became idle ? send ONE character
                uart_data <= msg_rom(msg_idx);
                write_en  <= 1'b1;
                sent_this_idle <= 1'b1;

                if (msg_idx == 17)
                    msg_idx <= 0;
                else
                    msg_idx <= msg_idx + 1;
            end
        end
    end

endmodule
