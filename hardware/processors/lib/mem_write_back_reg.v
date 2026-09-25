module mem_write_back_reg(
    input wire clk,
    input wire rst,
    input wire reg_write_control_in,
    output reg reg_write_control_out,
    input wire [31:0] load_op_data_in,
    output reg [31:0] load_op_data_out,
    input wire [31:0] alu_result_in,
    output reg [31:0] alu_result_out,
    input wire [31:0] u_type_immediate_in,
    input wire [2:0] write_back_mux_control_in,
    output reg [2:0] write_back_mux_control_out,
    input wire [4:0] dest_reg_in,
    output reg [4:0] dest_reg_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            load_op_data_out <= 32'b0;
            alu_result_out <= 32'b0;
            write_back_mux_control_out <= 3'b0;
            dest_reg_out <= 5'b0;
            reg_write_control_out <= 1'b0;
        end else begin 
            reg_write_control_out <= reg_write_control_in;
            dest_reg_out <= dest_reg_in;
            load_op_data_out <= load_op_data_in;
            alu_result_out <= alu_result_in;
            write_back_mux_control_out <= write_back_mux_control_in;
        end
    end

endmodule
