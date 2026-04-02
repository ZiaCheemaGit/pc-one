`timescale 1ns / 1ps

module load_op(
    input byte_op,
    input half_op,
    input unsigned_op,
    input [1:0] byte_offset,
    input [31:0] data_from_mem,
    output reg [31:0] op_data
);

    always @(*) begin
        if(byte_op) begin
            case(byte_offset)
            2'b00:
            op_data = unsigned_op ?
                {24'b0, data_from_mem[7:0]} :
                {{24{data_from_mem[7]}}, data_from_mem[7:0]};

            2'b01:
            op_data = unsigned_op ?
                {24'b0, data_from_mem[15:8]} :
                {{24{data_from_mem[15]}}, data_from_mem[15:8]};

            2'b10:
            op_data = unsigned_op ?
                {24'b0, data_from_mem[23:16]} :
                {{24{data_from_mem[23]}}, data_from_mem[23:16]};

            2'b11:
            op_data = unsigned_op ?
                {24'b0, data_from_mem[31:24]} :
                {{24{data_from_mem[31]}}, data_from_mem[31:24]};
            endcase
        end else if(half_op) begin
            case(byte_offset[1])
            1'b0:
            op_data = unsigned_op ?
                {16'b0, data_from_mem[15:0]} :
                {{16{data_from_mem[15]}}, data_from_mem[15:0]};

            1'b1:
            op_data = unsigned_op ?
                {16'b0, data_from_mem[31:16]} :
                {{16{data_from_mem[31]}}, data_from_mem[31:16]};
            endcase
        end else begin
            op_data = data_from_mem;
        end
    end

endmodule