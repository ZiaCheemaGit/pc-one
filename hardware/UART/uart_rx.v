`timescale 1ns / 1ps

/*

Debugging
0 = invalid data this should never be printed
5 = something recevied on rx
9 = rx is idle, also invalid data

*/

module uart_rx
(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    input  wire uart_read,

    output reg [31:0] data,
    output reg data_valid
);

    parameter CLK_FREQ = 25_000_000;
    parameter BAUD     = 9600;

    localparam CLKS_PER_BIT = CLK_FREQ / BAUD;
    localparam HALF_BIT     = CLKS_PER_BIT / 2;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state;
    reg [$clog2(CLKS_PER_BIT):0] clk_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    reg rx_sync0;
    reg rx_sync1;

    always @(posedge clk)
    begin
        rx_sync0 <= rx;
        rx_sync1 <= rx_sync0;
    end

    wire rx_s = rx_sync1;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= IDLE;
            clk_cnt <= 0;
            bit_cnt <= 0;
            shift_reg <= 0;
            data <= {24'b0, 8'h39};
            data_valid <= 0;
        end
        else
        begin

            if (uart_read)
            begin
                data_valid <= 0;
                data <= {24'b0, 8'h30};
            end

            case(state)

            IDLE:
            begin
                clk_cnt <= 0;
                bit_cnt <= 0;

                if (!rx_s)
                    state <= START;
            end

            START:
            begin
                if (clk_cnt == HALF_BIT)
                begin
                    if (!rx_s)
                    begin
                        clk_cnt <= 0;
                        state <= DATA;
                    end
                    else
                        state <= IDLE;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end

            DATA:
            begin
                if (clk_cnt == CLKS_PER_BIT-1)
                begin
                    clk_cnt <= 0;

                    shift_reg <= {rx_s, shift_reg[7:1]};

                    if (bit_cnt == 7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end

            STOP:
            begin
                if (clk_cnt == CLKS_PER_BIT-1)
                begin
                    clk_cnt <= 0;

                    if (rx_s)
                    begin
                        data <= {24'b0, shift_reg};
                        data_valid <= 1;
                    end

                    state <= IDLE;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end


            default:
                state <= IDLE;

            endcase

        end
    end

endmodule


