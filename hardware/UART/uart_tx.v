module uart_tx(
    input clk,
    input rst,
    input write_en,
    input [7:0] data,
    output reg tx,
    output reg uart_busy
);

    always @(posedge clk) begin
        if (write_en) begin
            tx <= data;
        end
    end

endmodule


