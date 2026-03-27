module uart_rx (
    input  wire clk,
    input  wire rst,
    input  wire rx,

    output reg  [7:0] data,
    output reg  data_valid
);

    parameter CLK_FREQ = 25_000_000;
    parameter BAUD     = 9600;
    localparam CLKS_PER_BIT = CLK_FREQ / BAUD;
    localparam HALF_BIT     = CLKS_PER_BIT / 2;

    localparam IDLE  = 0;
    localparam START = 1;
    localparam DATA  = 2;
    localparam STOP  = 3;

    reg [1:0] state;
    reg [$clog2(CLKS_PER_BIT):0] clk_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state      <= IDLE;
            clk_cnt    <= 0;
            bit_cnt    <= 0;
            data_valid <= 0;
        end
        else
        begin
            data_valid <= 0;

            case(state)

            IDLE:
            begin
                clk_cnt <= 0;
                bit_cnt <= 0;

                if(!rx)
                    state <= START;
            end

            START:
            begin
                if(clk_cnt == HALF_BIT)
                begin
                    clk_cnt <= 0;
                    state   <= DATA;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end

            DATA:
            begin
                if(clk_cnt == CLKS_PER_BIT-1)
                begin
                    clk_cnt <= 0;

                    shift_reg <= {rx, shift_reg[7:1]};

                    if(bit_cnt == 7)
                        state <= STOP;
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end

            STOP:
            begin
                if(clk_cnt == CLKS_PER_BIT-1)
                begin
                    data       <= shift_reg;
                    data_valid <= 1;
                    state      <= IDLE;
                    clk_cnt    <= 0;
                end
                else
                    clk_cnt <= clk_cnt + 1;
            end

            endcase
        end
    end

endmodule

