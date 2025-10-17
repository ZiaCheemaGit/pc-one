`timescale 1ns / 1ps

/*

pc control unit

this module is just made to also enable zero flag 
when branch instruction is executed to choose pc = branch address if zero_flag = 1
else pc = pc + 4

input comes from main control unit
output goes to pc_mux

*/ 

module pc_src_control(
    input [1:0] pc_mux_control,
    input zero_flag,
    output reg [1:0] pc_control
    );
    
    always @(*) begin
        if(pc_mux_control == 2'b01 && zero_flag == 1) begin
            pc_control = 01;
        end else begin
            pc_control = 00;
        end
    end

endmodule
