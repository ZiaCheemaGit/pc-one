# instruction formats

class B_instruction:
    def __init__(self, imm_12, rs2, rs1, funct3, opcode):
        self.rs2_str = self._to_binary_string(rs2, 5)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.funct3_str = self._to_binary_string(funct3, 3)

        bit_12   = (imm_12 >> 12) & 0x1
        bit_11   = (imm_12 >> 11) & 0x1
        bits_10_5 = (imm_12 >> 5)  & 0x3F 
        bits_4_1  = (imm_12 >> 1)  & 0xF 

        val_top = (bit_12 << 6) | bits_10_5
        self.imm_12_10_5_str = self._to_binary_string(val_top, 7)

        val_bot = (bits_4_1 << 1) | bit_11
        self.imm_4_1_11_str = self._to_binary_string(val_bot, 5)

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

    def get_binary_string(self) -> str:
        return (self.imm_12_10_5_str + 
                self.rs2_str + 
                self.rs1_str + 
                self.funct3_str + 
                self.imm_4_1_11_str + 
                self.opcode_str)
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)

class S_instruction:
    def __init__(self, imm_12, rs2, rs1, funct3, opcode):
        self.rs2_str = self._to_binary_string(rs2, 5)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.funct3_str = self._to_binary_string(funct3, 3)

        val_4_to_0 = imm_12 & 0x1F 
        val_11_to_5 = (imm_12 >> 5) & 0x7F

        self.imm_4_to_0_str = self._to_binary_string(val_4_to_0, 5)
        self.imm_11_to_5_str = self._to_binary_string(val_11_to_5, 7)

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

    def get_binary_string(self) -> str:
        return self.imm_11_to_5_str + self.rs2_str + self.rs1_str + self.funct3_str + self.imm_4_to_0_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)

class J_instruction:
    def __init__(self, imm, rd, opcode):
        self.imm_str = self._to_binary_string(imm, 20)
        self.rd_str = self._to_binary_string(rd, 5)
        self.opcode_str = self._to_binary_string(opcode, 7)

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

    def get_binary_string(self) -> str:
        return self.imm_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)

class R_instruction:
    def __init__(self, rs2, rs1, funct3, rd, opcode):
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.rs2_str = self._to_binary_string(rs2, 5)
        self.rd_str = self._to_binary_string(rd, 5)
        self.funct3_str = self._to_binary_string(funct3, 3)

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

    def get_binary_string(self) -> str:
        return "0000000" + self.rs2_str + self.rs1_str + self.funct3_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)

class I_instruction:
    def __init__(self, immediate, rs1, funct3, rd, opcode):
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.rd_str = self._to_binary_string(rd, 5)
        self.funct3_str = self._to_binary_string(funct3, 3)
        self.imm_str = self._to_binary_string(immediate, 12, True)
        
    def _to_binary_string(self, value, width, signed=False):
        if isinstance(value, str):
            return value.zfill(width)
        
        if not isinstance(value, int):
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

        if signed:
            if value >= 0:
                return f"{value:0{width}b}"
            else:
                two_comp_value = value & ((1 << width) - 1)
                return f"{two_comp_value:0{width}b}"
        else:
            return f"{value:0{width}b}"

    def get_binary_string(self) -> str:
        return self.imm_str + self.rs1_str + self.funct3_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)

class U_instruction:
    def __init__(self, immediate, rd, opcode):
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.rd_str = self._to_binary_string(rd, 5)
        self.imm_str = self._to_binary_string(immediate, 20)

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

    def get_binary_string(self) -> str:
        return self.imm_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)
    

