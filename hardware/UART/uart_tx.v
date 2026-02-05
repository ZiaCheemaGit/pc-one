module uart_tx(
    input clk,
    input rst,
    input write_en,
    input [7:0] data,
    output reg tx,
    output reg uart_busy
);

    parameter CLK_FREQ = 50_000_000;
    parameter BAUD     = 9600;

    localparam integer BAUD_CNT_MAX = CLK_FREQ / BAUD;

    reg [$clog2(BAUD_CNT_MAX)-1:0] baud_cnt;
    reg baud_tick;

    reg [3:0] bit_cnt;
    reg [9:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            baud_cnt  <= 0;
            baud_tick <= 1'b0;
        end else begin
            if (uart_busy) begin
                if (baud_cnt == BAUD_CNT_MAX-1) begin
                    baud_cnt  <= 0;
                    baud_tick <= 1'b1;
                end else begin
                    baud_cnt  <= baud_cnt + 1'b1;
                    baud_tick <= 1'b0;
                end
            end else begin
                baud_cnt  <= 0;
                baud_tick <= 1'b0;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx        <= 1'b1;
            uart_busy <= 1'b0;
            bit_cnt   <= 4'd0;
            shift_reg <= 10'b1111111111;
        end else begin
            if (write_en && !uart_busy) begin
                shift_reg <= {1'b1, data, 1'b0};
                uart_busy <= 1'b1;
                bit_cnt   <= 4'd0;
            end else if (uart_busy && baud_tick) begin
                tx <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                bit_cnt <= bit_cnt + 1'b1;

                if (bit_cnt == 4'd10) begin
                    uart_busy <= 1'b0;
                    bit_cnt   <= 4'd0;
                end
            end
        end
    end

endmodule
