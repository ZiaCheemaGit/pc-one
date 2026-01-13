module uart_tx(
    input clk,
    input reset,
    input write_en,
    input [7:0] data,
    output reg tx
);

    always @(posedge clk) begin
        if (write_en) begin
            tx <= data;
        end
    end

endmodule


