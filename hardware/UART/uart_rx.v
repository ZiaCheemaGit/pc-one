module uart_rx(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] data,
    output reg data_valid
);

parameter CLK_FREQ = 25_000_000;
parameter BAUD     = 9600;

localparam integer BAUD_CNT_MAX = CLK_FREQ / BAUD;

reg [$clog2(BAUD_CNT_MAX)-1:0] baud_cnt;
reg [3:0] bit_cnt;
reg [9:0] shift_reg;
reg receiving;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        baud_cnt <= 0;
        bit_cnt <= 0;
        receiving <= 0;
        data_valid <= 0;
    end else begin

        data_valid <= 0;

        if (!receiving) begin
            if (!rx) begin
                receiving <= 1;
                baud_cnt <= BAUD_CNT_MAX/2;
                bit_cnt <= 0;
            end
        end else begin

            if (baud_cnt == BAUD_CNT_MAX-1) begin
                baud_cnt <= 0;

                shift_reg <= {rx, shift_reg[9:1]};
                bit_cnt <= bit_cnt + 1;

                if (bit_cnt == 9) begin
                    receiving <= 0;
                    data <= shift_reg[8:1];
                    data_valid <= 1;
                end

            end else begin
                baud_cnt <= baud_cnt + 1;
            end

        end
    end
end

endmodule