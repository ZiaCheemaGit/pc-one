`timescale 1ns / 1ps

/*

0 = invalid data this should never be printed
5 = something recevied on rx
9 = rx is idle, also invalid data

*/
module uart_rx(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    input wire uart_read,
    output reg [31:0] data,
    output reg data_valid
);

    reg rx_prev;
    wire rx_falling = rx_prev && !rx;

    always @(posedge clk) begin
        rx_prev <= rx;
        if (uart_read) begin
            data <= {24'b0, 8'h30};
            data_valid <= 0;
        end else if (rx_falling) begin
            data <= {24'b0, 8'h35};
            data_valid <= 1;
        end
    end

endmodule


// module uart_rx
// (
//     input  wire clk,
//     input  wire rst,
//     input  wire rx,

//     output reg [7:0] data,
//     output reg data_valid
// );

//     parameter CLK_FREQ = 25_000_000;
//     parameter BAUD     = 9600;

//     localparam CLKS_PER_BIT = CLK_FREQ / BAUD;

//     localparam IDLE  = 2'd0;
//     localparam START = 2'd1;
//     localparam WAIT  = 2'd2;

//     reg [1:0] state;
//     reg [$clog2(CLKS_PER_BIT*10):0] clk_cnt;

//     /////////////////////////////////////////////////////////
//     // Synchronize RX input
//     /////////////////////////////////////////////////////////

//     reg rx_sync0;
//     reg rx_sync1;

//     always @(posedge clk)
//     begin
//         rx_sync0 <= rx;
//         rx_sync1 <= rx_sync0;
//     end

//     wire rx_s = rx_sync1;

//     /////////////////////////////////////////////////////////
//     // Frame detection FSM
//     /////////////////////////////////////////////////////////

//     always @(posedge clk or posedge rst)
//     begin
//         if (rst)
//         begin
//             state <= IDLE;
//             clk_cnt <= 0;
//             data_valid <= 0;
//         end
//         else
//         begin
//             case(state)

//             /////////////////////////////////////////////////////
//             // Wait for start bit
//             /////////////////////////////////////////////////////

//             IDLE:
//             begin
//                 clk_cnt <= 0;

//                 if (!rx_s)
//                 begin
//                     data_valid <= 0;   // new frame incoming
//                     state <= START;
//                 end
//             end


//             /////////////////////////////////////////////////////
//             // Validate start bit center
//             /////////////////////////////////////////////////////

//             START:
//             begin
//                 if (clk_cnt == CLKS_PER_BIT/2)
//                 begin
//                     if (!rx_s)
//                     begin
//                         clk_cnt <= 0;
//                         state <= WAIT;
//                     end
//                     else
//                         state <= IDLE;
//                 end
//                 else
//                     clk_cnt <= clk_cnt + 1;
//             end


//             /////////////////////////////////////////////////////
//             // Wait full frame duration
//             /////////////////////////////////////////////////////

//             WAIT:
//             begin
//                 if (clk_cnt == (CLKS_PER_BIT*9))
//                 begin
//                     // data_valid <= 1;   
//                     state <= IDLE;
//                 end
//                 else
//                     clk_cnt <= clk_cnt + 1;
//             end


//             default:
//                 state <= IDLE;

//             endcase
//         end
//     end

// endmodule

