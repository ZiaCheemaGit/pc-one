"""

module cpu_core(
    input clk,
    input rst,
    output [31:0] instruction_address,
    input [31:0] instruction,
    output mem_write,
    output mem_read,
    output [31:0] mem_address,
    input [31:0] mem_data_from_mem,
    output [31:0] mem_data_to_mem
    );

"""

import logging, sys, os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

current_dir = os.path.dirname(os.path.abspath(__file__))
target_dir = os.path.join(current_dir, '..', '..', '..')
python_classes_parent_dir = os.path.normpath(target_dir)
if python_classes_parent_dir not in sys.path:
    sys.path.append(python_classes_parent_dir)

from python_helper_classes.instructions import *

@cocotb.test
async def test_instruction_formats(dut):

    logger = logging.getLogger("cocotb.test_instruction_formats")

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk, 1, unit="ns").start()) 

    # cpu picks up auipc 5, 100
    dut.instruction.value = U_instruction(100, 5, "0010111").get_value()

    # reset cpu 
    dut.rst.value = 1
    await Timer(10, unit="ns") 
    dut.rst.value = 0   
    await RisingEdge(dut.clk) 

    logger.info("Reset Completed")
    logger.critical(f"PC = {dut.instruction_address.value.to_unsigned()}")

    # auipc 5, 100 is completed
    # cpu picks up addi 5, 5, 16
    dut.instruction.value = I_instruction(16, 5, 0, 5, "0010011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"After auipc 5, 100 Value of reg5 = {dut.reg_file_instance.registers[5].value.to_unsigned()}"
                    + f" AND PC = {dut.instruction_address.value.to_unsigned()}")
     
    # addi 5, 5, 16 completed
    # cpu picks up addi 4, 0, 16
    dut.instruction.value = I_instruction(16, 0, 0, 4, "0010011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"After addi 5, 5, 16 Value of reg5 = {dut.reg_file_instance.registers[5].value.to_unsigned()}"
                    + f" AND PC = {dut.instruction_address.value.to_unsigned()}")

    # addi 4, 0, 16 completed
    # cpu picks up  add 3, 4,5
    dut.instruction.value = R_instruction(5, 4, 0, 3, "0110011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"After addi 4, 0, 16 Value of reg4 = {dut.reg_file_instance.registers[4].value.to_unsigned()}"
                    + f" AND PC = {dut.instruction_address.value.to_unsigned()}")

    # add 3, 4, 5 completed
    # cpu picks up jal 2, 128
    dut.instruction.value = J_instruction(128, 2, "1101111").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"After add 3, 4, 5 Value of reg3 = {dut.reg_file_instance.registers[3].value.to_unsigned()}"
                    + f" AND PC = {dut.instruction_address.value.to_unsigned()}")

    # jal 2, 128 completed
    # cpu picks up sw 5, 20(2) 
    dut.instruction.value = S_instruction(20, 5, 2, "010", "0100011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"After jal 2, 128 Value of reg2 = {dut.reg_file_instance.registers[2].value.to_unsigned()}"
                    + f" AND PC = {dut.instruction_address.value.to_unsigned()}")
    
    # sw 5, 20(2) completed
    # cpu picks up beq 
    await RisingEdge(dut.clk)

    logger.info(f"After sw 5, 20(2) Value of mem_address = {dut.mem_address.value.to_unsigned()}"
                    + f" AND mem_write = {dut.mem_write.value}"
                    + f" AND mem_read = {dut.mem_read.value}"
                    + f" AND mem_data_from_mem = {dut.mem_data_from_mem.value}"
                    + f" AND mem_data_to_mem = {dut.mem_data_to_mem.value.to_unsigned()}"
                    + f" AND PC = {dut.instruction_address.value.to_unsigned()}")
    
@cocotb.test
async def test_b_type(dut):

    logger = logging.getLogger("cocotb.test_b_type")

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk, 1, unit="ns").start()) 

    # cpu picks up addi 4, 0, 16
    dut.instruction.value = I_instruction(16, 0, 0, 4, "0010011").get_value()

    # reset cpu 
    dut.rst.value = 1
    await Timer(10, unit="ns") 
    dut.rst.value = 0   
    await RisingEdge(dut.clk) 

    logger.info("Reset Completed")
    logger.info(f"PC = {dut.instruction_address.value.to_unsigned()}")

    # addi 4, 0, 16 completed
    # cpu picks up addi 5, 0, 16
    dut.instruction.value = I_instruction(16, 0, 0, 5, "0010011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"adddi 4, 0, 16 completed AND PC = {dut.instruction_address.value.to_unsigned()}")

    # addi 5, 0, 16 completed
    # cpu picks up beq 4, 0, 200
    dut.instruction.value = B_instruction(200, 0, 4, 0, "1100011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"addi 5, 0, 16 completed AND PC = {dut.instruction_address.value.to_unsigned()}")

    # beq 4, 0, 200 completed
    # cpu picks up beq 4, 5, 200
    dut.instruction.value = B_instruction(200, 4, 5, 0, "1100011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"beq 4, 0, 200 completed AND PC = {dut.instruction_address.value.to_unsigned()}")

    # beq 4, 5, 200 completed
    # cpu picks up beq 4, 5, 200
    dut.instruction.value = B_instruction(200, 4, 5, 0, "1100011").get_value()
    await RisingEdge(dut.clk)

    logger.info(f"beq 4, 5, 200 completed AND PC = {dut.instruction_address.value.to_unsigned()}")

@cocotb.test
async def test_math_asm(dut):

    logger = logging.getLogger("cocotb.test_math_asm")

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk, 1, unit="ns").start()) 

    logger.info(f"register2 = {dut.reg_file_instance.registers[2].value.to_unsigned()}")

    # cpu picks up addi	x2,x2,-32
    dut.instruction.value = I_instruction(-32, 2, 0, 2, "0010011").get_value()
    
    # reset cpu 
    dut.rst.value = 1
    await Timer(10, unit="ns") 
    dut.rst.value = 0   
    await RisingEdge(dut.clk)

    logger.info("Reset Completed")
    logger.critical(f"PC = {dut.instruction_address.value.to_unsigned()}")
    logger.info(f"instruction = 0x{dut.instruction.value.to_unsigned():08x}")

    # addi	x2,x2,-32 completed
    # cpu picks up sw	x8,28(x2)
    dut.instruction.value = I_instruction(28, 2, "010", 8, "0100011").get_value()
    await RisingEdge(dut.clk)

    logger.critical(f"PC = {dut.instruction_address.value.to_unsigned()}")
    logger.info(f"instruction = 0x{dut.instruction.value.to_unsigned():08x}")
    logger.info(f"register2 = {dut.reg_file_instance.registers[2].value.to_signed()}")
