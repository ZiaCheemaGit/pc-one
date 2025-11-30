`timescale 1ns / 1ps

/**

alu op values
00 = forced addition for load, store, jalr and dont care for others
01 = B-type branch
10 = I-type
11 = R-type

fun3 and fun7 values 

B-type fun3  alu-operation
BEQ	   000     sub
BNE	   001     sub + invert
BLT	   100     slt
BGE	   101     slt + invert
BLTU   110     sltu
BGEU   111     sltu + invert

I-type fun3 fun7[5]
ADDI	000	    -
SLTI	010	    -
SLTIU	011	    -
XORI	100	    -
ORI	    110	    -
ANDI	111	    -
SLLI	001	    -
SRLI	101	    -
SRAI	101	    1

R-type fun3 fun7[5]
ADD	   000	0
SUB	   000	1
SLL	   001	0
SLT	   010	0
SLTU   011	0
XOR	   100	0
SRL	   101	0
SRA	   101	1
OR	   110	0
AND	   111	0

out controls what operation alu performs out values to operation 
is same as defined in main_alu

**/

module alu_control(
    input [1:0] alu_op,
    input [2:0] fun3,
    input [6:0] fun7,
    output reg [3:0] out,
    output reg invert
    );
    
    always @(*) begin
    invert = 0;
        case(alu_op) 
        
            2'b00: out = 4'd2; 
            
            2'b01: begin     
                case (fun3)
                    3'b000: out = 4'd3;   
                    3'b001: begin out = 4'd3; invert = 1; end   
                    3'b100: out = 4'd6;   
                    3'b101: begin out = 4'd6; invert = 1; end 
                    3'b110: out = 4'd7;  
                    3'b111: begin out = 4'd7; invert = 1; end
                    default: out = 4'd0;
                endcase
            end
            
            2'b10: begin       
                case ({fun7[5], fun3})   
                    4'b0000: out = 4'd2;  
                    4'b0111: out = 4'd0;  
                    4'b0110: out = 4'd1;  
                    4'b0100: out = 4'd4;  
                    4'b0010: out = 4'd6;  
                    4'b0011: out = 4'd7;  
                    4'b0001: out = 4'd5; 
                    
                    4'b1000: out = 4'd2;  
                    4'b1111: out = 4'd0;  
                    4'b1110: out = 4'd1;  
                    4'b1100: out = 4'd4;  
                    4'b1010: out = 4'd6;  
                    4'b1011: out = 4'd7;  
                    4'b1001: out = 4'd5; 
                    
                    4'b0101: out = 4'd8; 
                    4'b1101: out = 4'd9; 
                    default: out = 4'd0;
                endcase
            end
            
            2'b11: begin        
                case ({fun7[5], fun3})
                    4'b0000: out = 4'd2;  
                    4'b1000: out = 4'd3; 
                    4'b0111: out = 4'd0; 
                    4'b0110: out = 4'd1; 
                    4'b0100: out = 4'd4; 
                    4'b0001: out = 4'd5; 
                    4'b0101: out = 4'd8; 
                    4'b1101: out = 4'd9; 
                    4'b0010: out = 4'd6;  
                    4'b0011: out = 4'd7;  
                    default: out = 4'd0;
                endcase
            end          
            
        endcase 
    end
    
endmodule
