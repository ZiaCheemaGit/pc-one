/**

control signals are generated based on opcode

pc_src controls what will be stored to pc
00 = pc + 4
01 = pc + immediate branch
10 = jal pc 
11 = jalr_pc

mem_to_reg is control for write back to register mux and selection values are 
000 = alu_out
001 = data_memory
010 = pc + 4
011 = u_type_immediate
100 = pc + u_type_immediate

alu_op is control for alu control unit and selection values are same as defined in alu_control module

**/
module control_unit (
    input [6:0] opcode,
    output reg branch, mem_read, mem_write, alu_src, reg_write,
    output reg [1:0] alu_op, 
    output reg [2:0] mem_to_reg
);

    always @(*) begin
        case (opcode)
            
            // R-Type
            7'd51: begin
            alu_src = 0;
            mem_to_reg = 3'b000;
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b11;
            end

            // I-Format
            7'd19: begin
            alu_src = 1;
            mem_to_reg = 3'b000;
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b10;
            end

            // load-Format
            7'd3: begin
            alu_src = 1;
            mem_to_reg = 3'b001;
            reg_write = 1;
            mem_read = 1;
            mem_write = 0;
            alu_op = 2'b00;
            end

            // store-Format
            7'd35: begin
            alu_src = 1;
            mem_to_reg = 3'b000; 
            reg_write = 0;
            mem_read = 0;
            mem_write = 1;
            alu_op = 2'b00;
            end

            // branch-Format
            7'd99: begin
            alu_src = 0;
            mem_to_reg = 3'b000; 
            reg_write = 0;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b01;
            end
            
            // jal
            7'd111: begin
            alu_src = 0;
            mem_to_reg = 3'b010; 
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b00; 
            end
            
            // jalr
            7'd103: begin
            alu_src = 1;
            mem_to_reg = 3'b010; 
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b00;
            end
            
            // lui
            7'd55: begin
            alu_src = 0;
            mem_to_reg = 3'b011; 
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b00;
            end
            
            // auipc
            7'd23: begin
            alu_src = 0;
            mem_to_reg = 3'b100; 
            reg_write = 1;
            mem_read = 0;
            mem_write = 0;
            alu_op = 2'b00;
            end

        endcase
    end
    
endmodule