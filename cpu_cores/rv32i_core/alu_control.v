/**

fun3 and fun7 values only matter for R-type and I-type

alu op values
11 = R-type
10 = I-type
01 = B-type branch
00 = forced addition for load, store, jalr and dont care for others

out controls what operation alu performs out values to operation 
is same as defined in main_alu

**/

module alu_control(
    input [1:0] alu_op,
    input [2:0] fun3,
    input [6:0] fun7,
    output reg [3:0] out
    );
    
    always @(*) begin
        case(alu_op) 
            2'b00: 
                out = 4'd2;
                
            2'b01: 
                out = 4'd1;
            
            2'b10: out = 4'd2;
            2'b11: out = 4'd3;            
        endcase 
    end
    
endmodule
