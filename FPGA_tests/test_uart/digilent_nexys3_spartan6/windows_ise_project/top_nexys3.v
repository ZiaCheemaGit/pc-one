`timescale 1ns/1ps

// module top_nexys3(
//     input  wire clk_from_FPGA,
//     input  wire rst_from_FPGA,
//     output wire rst_on,
//     output wire uart_tx_pin_for_FPGA
// );

//     assign rst_on = rst_from_FPGA;

//     reg  [7:0] uart_data;
//     reg        write_en;
//     wire       uart_busy;

//     uart_tx uart_instance (
//         .clk(clk_from_FPGA),
//         .rst(rst_from_FPGA),
//         .write_en(write_en),
//         .data(uart_data),
//         .tx(uart_tx_pin_for_FPGA),
//         .uart_busy(uart_busy)
//     );

//     reg  [31:0] pc_reg;
//     wire [31:0] instruction;

//     rom rom_instance (
//         .pc(pc_reg),
//         .instruction(instruction),
//         .addr(32'b0),   // unused for now
//         .data()         // unused for now
//     );

//     localparam FETCH_PC     = 2'd0;
//     localparam FETCH_ROM    = 2'd1;
//     localparam LATCH_INST  = 2'd2;
//     localparam SEND        = 2'd3;

//     reg [1:0]  state;
//     reg [3:0]  nibble_idx;
//     reg        sent_this_idle;
//     reg [31:0] instr_latched;

//     function [7:0] hex_char(input [3:0] nibble);
//         begin
//             if (nibble < 10)
//                 hex_char = "0" + nibble;
//             else
//                 hex_char = "A" + (nibble - 10);
//         end
//     endfunction

//     always @(posedge clk_from_FPGA) begin
//         if (rst_from_FPGA) begin
//             pc_reg         <= 32'h0000_0000;
//             instr_latched  <= 32'h0000_0000;
//             state          <= FETCH_PC;
//             nibble_idx     <= 0;
//             uart_data      <= 8'h00;
//             write_en       <= 1'b0;
//             sent_this_idle <= 1'b0;
//         end else begin
//             write_en <= 1'b0;

//             if (uart_busy)
//                 sent_this_idle <= 1'b0;

//             case (state)

//                 FETCH_PC: begin
//                     state <= FETCH_ROM;
//                 end

//                 FETCH_ROM: begin
//                     state <= LATCH_INST;
//                 end

//                 LATCH_INST: begin
//                     instr_latched <= instruction;
//                     nibble_idx <= 0;
//                     state <= SEND;
//                 end

//                 SEND: begin
//                     if (!uart_busy && !sent_this_idle) begin
//                         sent_this_idle <= 1'b1;

//                         case (nibble_idx)
//                             0: begin uart_data <= hex_char(instr_latched[31:28]); write_en <= 1'b1; nibble_idx <= 1; end
//                             1: begin uart_data <= hex_char(instr_latched[27:24]); write_en <= 1'b1; nibble_idx <= 2; end
//                             2: begin uart_data <= hex_char(instr_latched[23:20]); write_en <= 1'b1; nibble_idx <= 3; end
//                             3: begin uart_data <= hex_char(instr_latched[19:16]); write_en <= 1'b1; nibble_idx <= 4; end
//                             4: begin uart_data <= hex_char(instr_latched[15:12]); write_en <= 1'b1; nibble_idx <= 5; end
//                             5: begin uart_data <= hex_char(instr_latched[11:8 ]); write_en <= 1'b1; nibble_idx <= 6; end
//                             6: begin uart_data <= hex_char(instr_latched[7 :4 ]); write_en <= 1'b1; nibble_idx <= 7; end
//                             7: begin uart_data <= hex_char(instr_latched[3 :0 ]); write_en <= 1'b1; nibble_idx <= 8; end
//                             8: begin uart_data <= 8'h0D; write_en <= 1'b1; nibble_idx <= 9; end
//                             9: begin
//                                 uart_data <= 8'h0A;
//                                 write_en  <= 1'b1;
//                                 pc_reg    <= pc_reg + 4;
//                                 state     <= FETCH_PC;
//                             end
//                         endcase
//                     end
//                 end

//             endcase
//         end
//     end

// endmodule


module top_nexys3(
    input  wire clk_from_FPGA,
    input  wire rst_from_FPGA,
    output wire rst_on,
    output wire uart_tx_pin_for_FPGA
);

    assign rst_on = rst_from_FPGA;

    pc_one pc_one_instance(
        .clk_from_FPGA(clk_from_FPGA),
        .rst_from_FPGA(rst_from_FPGA),
        .uart_tx_pin_for_FPGA(uart_tx_pin_for_FPGA)
    );

endmodule


