# instruction formats

class B_instruction:
    def __init__(self, imm_12, rs2, rs1, funct3, opcode, mnemonic):
        self.rs2_str = self._to_binary_string(rs2, 5)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.funct3_str = self._to_binary_string(funct3, 3)
        self.mnemonic = mnemonic
        self.imm_12 = imm_12

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

    def _sign_extend(self, bin_str):
        bits = len(bin_str)
        value = int(bin_str, 2)
        if value & (1 << (bits - 1)):
            value -= (1 << bits)
        return value

    def get_binary_string(self) -> str:
        return (self.imm_12_10_5_str + 
                self.rs2_str + 
                self.rs1_str + 
                self.funct3_str + 
                self.imm_4_1_11_str + 
                self.opcode_str)
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)
    
    def get_asm(self):
        return f"{self.mnemonic} x{int(self.rs1_str, 2)}, x{int(self.rs2_str, 2)}, {self._sign_extend(self.imm_12)}"

class S_instruction:
    def __init__(self, imm_12, rs2, rs1, funct3, opcode, mnemonic):
        self.rs2_str = self._to_binary_string(rs2, 5)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.funct3_str = self._to_binary_string(funct3, 3)
        self.mnemonic = mnemonic
        
        if isinstance(imm_12, int):
            raw_imm = imm_12 & 0xFFF 
        elif isinstance(imm_12, str):
            raw_imm = int(imm_12, 0) & 0xFFF
        else:
            raise TypeError("Immediate must be int or str")

        val_4_to_0 = raw_imm & 0x1F 
        val_11_to_5 = (raw_imm >> 5) & 0x7F

        self.imm_4_to_0_str = self._to_binary_string(val_4_to_0, 5)
        self.imm_11_to_5_str = self._to_binary_string(val_11_to_5, 7)

    def _to_binary_string(self, value, width):
        if isinstance(value, str):
            if value.startswith('-'):
                value = int(value, 0)
            else:
                return value.zfill(width)
        
        if isinstance(value, int):
            value = value & ((1 << width) - 1)
            return f"{value:0{width}b}"
            
        raise TypeError(f"Instruction field must be int or str, got {type(value)}")
        
    def _sign_extend(self, bin_str):
        bits = len(bin_str)
        value = int(bin_str, 2)
        if value & (1 << (bits - 1)):
            value -= (1 << bits)
        return value

    def get_binary_string(self) -> str:
        return (self.imm_11_to_5_str + self.rs2_str + self.rs1_str + 
                self.funct3_str + self.imm_4_to_0_str + self.opcode_str)
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)
    
    def get_asm(self):
        full_imm_str = self.imm_11_to_5_str + self.imm_4_to_0_str
        offset = self._sign_extend(full_imm_str)
        
        return f"{self.mnemonic} x{int(self.rs2_str, 2)}, {offset}(x{int(self.rs1_str, 2)})"
    
class J_instruction:
    def __init__(self, imm, rd, opcode, mnemonic):
        self.immediate_proper = imm
        val_imm = int(imm)
        imm_bin = f"{val_imm & 0x1FFFFF:021b}"
        bit_20     = imm_bin[0]       # imm[20]
        bits_19_12 = imm_bin[1:9]     # imm[19:12]
        bit_11     = imm_bin[9]       # imm[11]
        bits_10_1  = imm_bin[10:20]   # imm[10:1]
        
        self.imm_str = bit_20 + bits_10_1 + bit_11 + bits_19_12
        self.rd_str = self._to_binary_string(rd, 5)
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.mnemonic = mnemonic

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")
    
    def _sign_extend(self, bin_str):
        bits = len(bin_str)
        value = int(bin_str, 2)
        if value & (1 << (bits - 1)):    # if MSB = 1 → negative
            value -= (1 << bits)
        return value

    def get_binary_string(self) -> str:
        return self.imm_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)
    
    def get_asm(self):
        return f"{self.mnemonic} x{int(self.rd_str, 2)}, {self._sign_extend(self.immediate_proper)}"

class R_instruction:
    def __init__(self, rs2, rs1, funct3, funct7, rd, opcode, mnemonic):
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.rs2_str = self._to_binary_string(rs2, 5)
        self.rd_str = self._to_binary_string(rd, 5)
        self.funct3_str = self._to_binary_string(funct3, 3)
        self.funct7_str = self._to_binary_string(funct7, 7)
        self.mnemonic = mnemonic

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
    
    def get_asm(self):
        return f"{self.mnemonic} x{int(self.rd_str, 2)}, x{int(self.rs1_str, 2)}, x{int(self.rs2_str, 2)}"

class I_instruction:
    def __init__(self, immediate, rs1, funct3, rd, opcode, mnemonic):
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.rs1_str = self._to_binary_string(rs1, 5)
        self.rd_str = self._to_binary_string(rd, 5)
        self.funct3_str = self._to_binary_string(funct3, 3)
        self.imm_str = self._to_binary_string(immediate, 12, True)
        self.mnemonic = mnemonic

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

    def _sign_extend(self, bin_str):
        bits = len(bin_str)
        value = int(bin_str, 2)
        if value & (1 << (bits - 1)):    # if MSB = 1 → negative
            value -= (1 << bits)
        return value

    def get_binary_string(self) -> str:
        return self.imm_str + self.rs1_str + self.funct3_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)
    
    def get_asm(self):
        # Arithmetic I-Type
        if self.mnemonic[-1] == 'i' or self.mnemonic[0] == 'j':
            return f"{self.mnemonic} x{int(self.rd_str, 2)}, x{int(self.rs1_str, 2)}, {self._sign_extend(self.imm_str)}"
        # jalr
        elif self.mnemonic[0] == 'l':
            return f"{self.mnemonic} x{int(self.rd_str, 2)}, {self._sign_extend(self.imm_str)}(x{int(self.rs1_str, 2)})"
        
        return self.mnemonic

class U_instruction:
    def __init__(self, immediate, rd, opcode, mnemonic):
        self.opcode_str = self._to_binary_string(opcode, 7)
        self.rd_str = self._to_binary_string(rd, 5)
        self.imm_str = self._to_binary_string(immediate, 20)
        self.mnemonic = mnemonic

    def _to_binary_string(self, value, width):
        if isinstance(value, int):
            return f"{value:0{width}b}"
        elif isinstance(value, str):
            return value.zfill(width)
        else:
            raise TypeError(f"Instruction field must be int or str, got {type(value)}")

    def _sign_extend(self, bin_str):
        bits = len(bin_str)
        value = int(bin_str, 2)
        if value & (1 << (bits - 1)):    # if MSB = 1 → negative
            value -= (1 << bits)
        return value

    def get_binary_string(self) -> str:
        return self.imm_str + self.rd_str + self.opcode_str
    
    def get_value(self) -> int:
        return int(self.get_binary_string(), 2)
    
    def get_asm(self):
        return f"{self.mnemonic} x{int(self.rd_str, 2)}, {self._sign_extend(self.imm_str)}"
    
    