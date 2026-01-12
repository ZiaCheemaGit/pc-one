from instr_format.instructions import *

class MnemonicTable:
    def __init__(self):
        self.r_mnemonics = {
            ('000', '0000000'): "add",
            ('000', '0100000'): "sub", 
            ('001', '0000000'): "sll",
            ('010', '0000000'): "slt",
            ('011', '0000000'): "sltu",
            ('100', '0000000'): "xor",
            ('101', '0000000'): "srl",
            ('101', '0100000'): "sra",
            ('110', '0000000'): "or",
            ('111', '0000000'): "and",
        }

        self.i_mnemonics = {
            '000': 'addi',
            '010': 'slti',
            '011': 'sltiu',
            '100': 'xori',
            '110': 'ori',
            '111': 'andi',
        }

        self.load_mnemonics = {
            '000': 'lb',  
            '001': 'lh',  
            '010': 'lw',
            '100': 'lbu', 
            '101': 'lhu'
        }

        self.store_mnemonics = {
            '000': 'sb', 
            '001': 'sh', 
            '010': 'sw'
        }

        self.branch_mnemonics = {
            '000': 'beq', '001': 'bne',
            '100': 'blt', '101': 'bge',
            '110': 'bltu', '111': 'bgeu'
        }

        self.system_mnemonics = {
            '001': 'csrrw', 
            '010': 'csrrs', 
            '011': 'csrrc',
            '101': 'csrrwi',
            '110': 'csrrsi',
            '111': 'csrrci'
        }

    def get_mnemonic(self, opcode, funct3, funct7):

        if opcode == '0110011':
            return self.r_mnemonics.get((funct3, funct7), "unknown_r")

        elif opcode == '0010011':
            if funct3 == '001' and funct7 == '0000000':
                return "slli"
            
            elif funct3 == '101':
                if funct7 == '0000000': return "srli"
                if funct7 == '0100000': return "srai"

            return self.i_mnemonics.get(funct3, "unknown_i")

        elif opcode == '0000011':
            return self.load_mnemonics.get(funct3, "unknown_load")

        elif opcode == '0100011':
            return self.store_mnemonics.get(funct3, "unknown_store")

        elif opcode == '1100011':
            return self.branch_mnemonics.get(funct3, "unknown_branch")

        elif opcode == '1101111': return "jal"
        elif opcode == '1100111' and funct3 == '000': return "jalr"
        elif opcode == '0110111': return "lui"
        elif opcode == '0010111': return "auipc"

        elif opcode == '0001111': return "fence"
        elif opcode == '1110011':
            if funct3 == '000':
                return "sys_ecall_ebreak" 
            return self.system_mnemonics.get(funct3, "unknown_sys")

        return "unknown_op"

def binary_to_assembly(instruction: int) -> str:
    mnemonic_table = MnemonicTable()

    instruction = f'{instruction & 0xFFFFFFFF:032b}'

    opcode = instruction[25:32]

    rd     = instruction[20:25]
    funct3 = instruction[17:20]
    rs1    = instruction[12:17]
    rs2    = instruction[7:12]
    funct7 = instruction[0:7]
    immediate = instruction[0:12]
    s_immediate = instruction[0:7] + instruction[20:25]
    b_immediate = (instruction[0] + instruction[24] + instruction[1:7] + instruction[20:24] + '0') 
    u_immediate = instruction[0:20]
    j_immediate = (instruction[0] + instruction[12:20] + instruction[11] + instruction[1:11] + '0')

    match opcode:
        
        # B-Type
        case '1100011':
            mnemonic = mnemonic_table.get_mnemonic(opcode, funct3, funct7)
            return B_instruction(int(b_immediate, 2), rs2, rs1, funct3, opcode, mnemonic).get_asm()

        # S-Type
        case '0100011':
            mnemonic = mnemonic_table.get_mnemonic(opcode, funct3, funct7)
            return S_instruction(int(s_immediate, 2), rs2, rs1, funct3, opcode, mnemonic).get_asm()
        
        # J-Type
        case '1101111':
            mnemonic = mnemonic_table.get_mnemonic(opcode, funct3, funct7)
            return J_instruction(j_immediate, rd, opcode, mnemonic).get_asm()

        # R-Type
        case '0110011':
            mnemonic = mnemonic_table.get_mnemonic(opcode, funct3, funct7)
            return R_instruction(rs2, rs1, funct3, funct7, rd, opcode, mnemonic).get_asm()

        # I-Type
        case '0010011' | '0000011' | '1100111' | '1110011' | '0001111':
            mnemonic = mnemonic_table.get_mnemonic(opcode, funct3, funct7)
            if mnemonic in ['slli', 'srli', 'srai']:
                immediate_val = immediate_val & 0x1F
            return I_instruction(immediate, rs1, funct3, rd, opcode, mnemonic).get_asm()
        
        # U-Type
        case '0110111' | '0010111':
            mnemonic = mnemonic_table.get_mnemonic(opcode, funct3, funct7)
            return U_instruction(u_immediate, rd, opcode, mnemonic).get_asm()

        case _:
            return f"opcode = {opcode}(Unknown Instruction)"
