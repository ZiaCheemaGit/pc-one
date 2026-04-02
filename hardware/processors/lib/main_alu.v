`timescale 1ns / 1ps

/**

main_alu takes in two 32 bit inputs and based on 3rd input operation 
outputs the result as out and if out == 0 a zero flag also equals zero, otherwise 1

in case of bne invert == 1 so zero flag is inverted 

operations with corresponding decimal values
0 = AND
1 = OR
2 = ADD
3 = SUB
4 = XOR
5 = SLL  only lower 5 bits because max shift = 32 times and 2 ^ 5 = 32 we dont need rest higher bits
6 = SLT rd = 1 if rs1 < rs2 signed comparison
7 = SLTU same as slt but unsigned comparison
8 = SRL  only lower 5 bits because max shift = 32 times and 2 ^ 5 = 32 we dont need rest higher bits
9 = SRA arithmetic shift performes sign concious shift

**/

module main_alu(
    input invert,
    input [31:0] src1, src2,
    input [3:0] operation,
    output reg zero_flag,
    output reg [31:0] out
);

    always @(*) begin
        case (operation)
            4'b0000: out = src1 & src2;              
            4'b0001: out = src1 | src2;              
            4'b0010: out = src1 + src2;            
            4'b0011: out = src1 - src2;            
            4'b0100: out = src1 ^ src2;            
            4'b0101: out = src1 << src2[4:0];      
            4'b0110: out = ($signed(src1) < $signed(src2)) ? 1 : 0; 
            4'b0111: out = (src1 < src2) ? 1 : 0;  
            4'b1000: out = src1 >> src2[4:0];        
            4'b1001: out = $signed(src1) >>> src2[4:0]; 
            default: out = 32'h0;
        endcase

        if (invert == 1'b0)
            zero_flag = (out == 32'h0) ? 1'b1 : 1'b0; 
        else
            zero_flag = (out == 32'h0) ? 1'b0 : 1'b1;  
    end

endmodule


