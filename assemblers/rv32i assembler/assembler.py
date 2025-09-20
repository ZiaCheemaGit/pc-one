import sys

# RV32I opcodes 
OPCODES = {
    "LUI":   0b0110111,
    "AUIPC": 0b0010111,
    "JAL":   0b1101111,
    "JALR":  0b1100111,
    "BEQ":   0b1100011,
    "BNE":   0b1100011,
    "BLT":   0b1100011,
    "BGE":   0b1100011,
    "BLTU":  0b1100011,
    "BGEU":  0b1100011,
    "LW":    0b0000011,
    "SW":    0b0100011,
    "ADDI":  0b0010011,
    "SLTI":  0b0010011,
    "SLTIU": 0b0010011,
    "XORI":  0b0010011,
    "ORI":   0b0010011,
    "ANDI":  0b0010011,
    "SLLI":  0b0010011,
    "SRLI":  0b0010011,
    "SRAI":  0b0010011,
    "ADD":   0b0110011,
    "SUB":   0b0110011,
    "SLL":   0b0110011,
    "SLT":   0b0110011,
    "SLTU":  0b0110011,
    "XOR":   0b0110011,
    "SRL":   0b0110011,
    "SRA":   0b0110011,
    "OR":    0b0110011,
    "AND":   0b0110011
}

FUNCT3 = {
    "ADD": 0b000, "SUB": 0b000, "SLL": 0b001, "SLT": 0b010, "SLTU": 0b011,
    "XOR": 0b100, "SRL": 0b101, "SRA": 0b101, "OR": 0b110, "AND": 0b111,
    "ADDI": 0b000, "SLTI": 0b010, "SLTIU": 0b011, "XORI": 0b100, "ORI": 0b110,
    "ANDI": 0b111, "SLLI": 0b001, "SRLI": 0b101, "SRAI": 0b101,
    "LW": 0b010, "SW": 0b010,
    "BEQ":0b000, "BNE":0b001, "BLT":0b100, "BGE":0b101, "BLTU":0b110, "BGEU":0b111,
    "JALR":0b000
}

FUNCT7 = {
    "ADD": 0b0000000, "SUB": 0b0100000, "SLL":0b0000000, "SLT":0b0000000, "SLTU":0b0000000,
    "XOR":0b0000000, "SRL":0b0000000, "SRA":0b0100000, "OR":0b0000000, "AND":0b0000000,
    "SLLI":0b0000000, "SRLI":0b0000000, "SRAI":0b0100000
}

# create a dict like 
# {'x0': 0, 'x1':1, ...., 'x31':31}
REGS = {f"x{i}":i for i in range(32)}

# 32-bit integer into a little-endian hexadecimal string 
# for example "78563412" = int_to_hex_le(0x12345678)
def int_to_hex_le(val):
    b0 = val & 0xFF
    b1 = (val >> 8) & 0xFF
    b2 = (val >> 16) & 0xFF
    b3 = (val >> 24) & 0xFF
    return f"{b0:02x}{b1:02x}{b2:02x}{b3:02x}"

# Assembler function
def assemble_line(line):
    parts = line.replace(",", " ").split()
    if not parts:
        return None
    instr = parts[0].upper()
    
    # R-type
    if instr in ["ADD","SUB","SLL","SLT","SLTU","XOR","SRL","SRA","OR","AND"]:
        rd = REGS[parts[1]]
        rs1 = REGS[parts[2]]
        rs2 = REGS[parts[3]]
        opcode = OPCODES[instr]
        funct3 = FUNCT3[instr]
        funct7 = FUNCT7[instr]
        return (funct7<<25)|(rs2<<20)|(rs1<<15)|(funct3<<12)|(rd<<7)|opcode
    
    # I-type (ADDI, etc.)
    if instr in ["ADDI","SLTI","SLTIU","XORI","ORI","ANDI","SLLI","SRLI","SRAI","LW","JALR"]:
        rd = REGS[parts[1]]
        rs1 = REGS[parts[2]]
        imm = int(parts[3],0) & 0xFFF
        opcode = OPCODES[instr]
        funct3 = FUNCT3[instr]
        funct7 = FUNCT7.get(instr,0)
        if instr in ["SLLI","SRLI","SRAI"]:
            return (funct7<<25)|(imm<<20)|(rs1<<15)|(funct3<<12)|(rd<<7)|opcode
        return (imm<<20)|(rs1<<15)|(funct3<<12)|(rd<<7)|opcode
    
    # S-type (SW)
    if instr == "SW":
        rs2 = REGS[parts[1]]
        rs1 = REGS[parts[2]]
        imm = int(parts[3],0) & 0xFFF
        imm11_5 = (imm>>5)&0x7F
        imm4_0 = imm&0x1F
        opcode = OPCODES[instr]
        funct3 = FUNCT3[instr]
        return (imm11_5<<25)|(rs2<<20)|(rs1<<15)|(funct3<<12)|(imm4_0<<7)|opcode
    
    # B-type (BEQ, etc.)
    if instr in ["BEQ","BNE","BLT","BGE","BLTU","BGEU"]:
        rs1 = REGS[parts[1]]
        rs2 = REGS[parts[2]]
        imm = int(parts[3],0) & 0x1FFF  # 13-bit signed branch offset
        imm12 = (imm >> 12) & 0x1
        imm10_5 = (imm >>5) & 0x3F
        imm4_1 = (imm >>1) & 0xF
        imm11 = (imm >>11) & 0x1
        opcode = OPCODES[instr]
        funct3 = FUNCT3[instr]
        return (imm12<<31)|(imm10_5<<25)|(rs2<<20)|(rs1<<15)|(funct3<<12)|(imm4_1<<8)|(imm11<<7)|opcode
    
    # U-type (LUI, AUIPC)
    if instr in ["LUI","AUIPC"]:
        rd = REGS[parts[1]]
        imm = int(parts[2],0) & 0xFFFFF
        opcode = OPCODES[instr]
        return (imm<<12)|(rd<<7)|opcode
    
    # J-type (JAL)
    if instr == "JAL":
        rd = REGS[parts[1]]
        imm = int(parts[2],0) & 0x1FFFFF
        imm20 = (imm>>20)&1
        imm10_1 = (imm>>1)&0x3FF
        imm11 = (imm>>11)&1
        imm19_12 = (imm>>12)&0xFF
        opcode = OPCODES[instr]
        return (imm20<<31)|(imm19_12<<12)|(imm11<<20)|(imm10_1<<21)|(rd<<7)|opcode
    
    return None

def main():
    if len(sys.argv)!=3:
        print("Usage: python assembler.py input.asm output.hex")
        return
    
    in_file = sys.argv[1]
    out_file = sys.argv[2]
    
    with open(in_file,'r') as f:
        lines = f.readlines()
    
    with open(out_file,'w') as f:
        for line in lines:
            code = assemble_line(line)
            if code is not None:
                f.write(int_to_hex_le(code)+'\n')
    print(f"Assembled {len(lines)} lines to {out_file}")

if __name__=="__main__":
    main()
