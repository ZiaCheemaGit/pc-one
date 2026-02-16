module uart_tx(
    input  wire       clk,
    input  wire       rst,
    input  wire       write_en,
    input  wire [7:0] data,
    output wire       tx,
    output reg        uart_busy
);

    parameter CLK_FREQ = 10_000_000;
    parameter BAUD     = 9600;

    localparam integer BAUD_CNT_MAX = (CLK_FREQ / BAUD) - 1;

    // --------------------------------------------------
    // State
    // --------------------------------------------------
    reg [$clog2(BAUD_CNT_MAX+1)-1:0] baud_cnt;
    reg [3:0]  bit_cnt;
    reg [9:0]  shift_reg;

    // --------------------------------------------------
    // TX line is ALWAYS driven by shift register
    // --------------------------------------------------
    assign tx = shift_reg[0];

    // --------------------------------------------------
    // UART transmit logic
    // --------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 10'b1111111111; // idle HIGH
            baud_cnt  <= 0;
            bit_cnt   <= 0;
            uart_busy <= 0;
        end else begin
            if (!uart_busy) begin
                // Load new byte only when idle
                if (write_en) begin
                    shift_reg <= {1'b1, data, 1'b0}; // stop, data, start
                    uart_busy <= 1'b1;
                    baud_cnt  <= 0;
                    bit_cnt   <= 0;
                end
            end else begin
                // Actively transmitting
                if (baud_cnt == BAUD_CNT_MAX) begin
                    baud_cnt  <= 0;
                    shift_reg <= {1'b1, shift_reg[9:1]};
                    bit_cnt   <= bit_cnt + 1'b1;

                    // Sent start + 8 data + stop = 10 bits
                    if (bit_cnt == 4'd9) begin
                        uart_busy <= 1'b0;
                        bit_cnt   <= 0;
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1'b1;
                end
            end
        end
    end

endmodule
