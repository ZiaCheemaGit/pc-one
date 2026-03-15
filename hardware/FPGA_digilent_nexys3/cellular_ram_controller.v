`timescale 1ns/1ps

module cellular_ram_controller(

    input clk,
    input reset,

    // request interface
    input read_req,
    input write_req,
    input [23:0] addr,
    input [15:0] write_data,
    input [1:0]  byte_en,

    output reg [15:0] read_data,
    output reg ready,

    // Nexys3 Cellular RAM pins
    output reg [23:0] MT_ADDR,
    inout [15:0] MT_DQ,
    output reg MT_CE,
    output reg MT_OE,
    output reg MT_WE,
    output reg MT_LB,
    output reg MT_UB
);

reg [15:0] dq_out;
reg dq_drive;

assign MT_DQ = dq_drive ? dq_out : 16'bz;
wire [15:0] dq_in = MT_DQ;

reg [2:0] state;

localparam
IDLE   = 0,
READ1  = 1,
READ2  = 2,
WRITE1 = 3,
WRITE2 = 4;

always @(posedge clk or posedge reset) begin

    if(reset) begin
        state <= IDLE;
        ready <= 1;
        MT_CE <= 1;
        MT_OE <= 1;
        MT_WE <= 1;
        dq_drive <= 0;
    end

    else begin
        case(state)

        IDLE:
        begin
            ready <= 1;
            MT_CE <= 1;
            MT_OE <= 1;
            MT_WE <= 1;
            dq_drive <= 0;

            if(read_req) begin
                ready <= 0;
                MT_ADDR <= addr;
                MT_CE <= 0;
                MT_OE <= 0;
                MT_WE <= 1;

                MT_LB <= ~byte_en[0];
                MT_UB <= ~byte_en[1];

                state <= READ1;
            end

            else if(write_req) begin
                ready <= 0;
                MT_ADDR <= addr;

                dq_out <= write_data;
                dq_drive <= 1;

                MT_CE <= 0;
                MT_WE <= 0;
                MT_OE <= 1;

                MT_LB <= ~byte_en[0];
                MT_UB <= ~byte_en[1];

                state <= WRITE1;
            end
        end

        READ1:
            state <= READ2;

        READ2:
        begin
            read_data <= dq_in;

            MT_CE <= 1;
            MT_OE <= 1;

            state <= IDLE;
        end

        WRITE1:
            state <= WRITE2;

        WRITE2:
        begin
            MT_WE <= 1;
            MT_CE <= 1;
            dq_drive <= 0;

            state <= IDLE;
        end

        endcase
    end
end

endmodule