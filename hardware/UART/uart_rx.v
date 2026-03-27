module uart_rx(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output reg  [7:0] data,
    output wire busy
);

    parameter CLK_FREQ = 25_000_000;
    parameter BAUD     = 9600;

    localparam integer BAUD_CNT_MAX = CLK_FREQ / BAUD;
    localparam integer HALF_BAUD    = BAUD_CNT_MAX / 2;

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [$clog2(BAUD_CNT_MAX):0] baud_cnt;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    /*
    busy definition updated:

    busy = 1 → currently receiving UART frame
    busy = 0 → receiver idle (data available and stable)
    */

    assign busy = (state != IDLE);

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state     <= IDLE;
            baud_cnt  <= 0;
            bit_cnt   <= 0;
            shift_reg <= 0;
            data      <= 0;
        end
        else
        begin
            case (state)

            IDLE:
            begin
                baud_cnt <= 0;
                bit_cnt  <= 0;

                if (!rx)              // detect start bit
                    state <= START;
            end

            START:
            begin
                if (baud_cnt == HALF_BAUD)
                begin
                    baud_cnt <= 0;
                    state <= DATA;
                end
                else
                    baud_cnt <= baud_cnt + 1;
            end

            DATA:
            begin
                if (baud_cnt == BAUD_CNT_MAX-1)
                begin
                    baud_cnt <= 0;

                    shift_reg <= {rx, shift_reg[7:1]};

                    if (bit_cnt == 7)
                    begin
                        bit_cnt <= 0;
                        state <= STOP;
                    end
                    else
                        bit_cnt <= bit_cnt + 1;
                end
                else
                    baud_cnt <= baud_cnt + 1;
            end

            STOP:
            begin
                if (baud_cnt == BAUD_CNT_MAX-1)
                begin
                    baud_cnt <= 0;
                    state <= IDLE;

                    data <= shift_reg;   // overwrite only when new byte arrives
                end
                else
                    baud_cnt <= baud_cnt + 1;
            end

            endcase
        end
    end

endmodule