"""

module top(
    input clk,
    input rst
    );

"""

import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from python_helper_classes.converter import *

@cocotb.test()
async def test_asm(dut):

    logger = logging.getLogger("test")
    file_handler = logging.FileHandler("simulation.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk, 1, unit="ns").start()) 

    # reset cpu 
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    logger.info("Reset released. CPU starting execution.")
    
    for i in range(2000):

        # PC
        try: 
            logger.critical(f"PC = {dut.instr_add.value.to_unsigned()}")
            logger.critical(f"PC = 0x{dut.instr_add.value.to_unsigned():08x}")
        except Exception:
            logger.critical(f"PC = {dut.instr_add.value}")

        # Instruction 
        try: 
            logger.info(f"instruction = {binary_to_assembly((dut.instruction.value.to_unsigned()))}")
        except Exception:
            logger.info(f"instruction = {dut.instruction.value}")

        # reg_write_control
        try: 
            logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value.to_unsigned()}")
        except Exception:
            logger.info(f"reg_write_control = {dut.core_instance.reg_file_instance.reg_write_control.value}")   

        # reg_write_data
        try: 
            logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value.to_unsigned()}")
        except Exception:
            logger.info(f"reg_write_data = {dut.core_instance.reg_file_instance.reg_write_data.value}")   

        # dest_reg
        try: 
            logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value.to_unsigned()}")
        except Exception:
            logger.info(f"dest_reg = {dut.core_instance.reg_file_instance.dest_reg.value}")   

        # mem_write
        try: 
            logger.info(f"mem_write = {dut.ram_16KB_instance.mem_write.value.to_unsigned()}")
        except Exception:
            logger.info(f"mem_write = {dut.ram_16KB_instance.mem_write.value}")

        # data_in
        try: 
            logger.info(f"data_in = {dut.ram_16KB_instance.data_in.value.to_unsigned()}")
        except Exception:
            logger.info(f"data_in = {dut.ram_16KB_instance.data_in.value}")

        # mem_read
        try: 
            logger.info(f"mem_read = {dut.ram_16KB_instance.mem_read.value.to_unsigned()}")
        except Exception:
            logger.info(f"mem_read = {dut.ram_16KB_instance.mem_read.value}")

        # data_out
        try: 
            logger.info(f"data_out = {dut.ram_16KB_instance.data_out.value.to_unsigned()}")
        except Exception:
            logger.info(f"data_out = {dut.ram_16KB_instance.data_out.value}")

        # data_address
        try: 
            logger.info(f"data_address = {dut.ram_16KB_instance.data_address.value.to_unsigned()}")
        except Exception:
            logger.info(f"data_address = {dut.ram_16KB_instance.data_address.value}")

        await RisingEdge(dut.clk)

        if dut.instr_add.value.to_unsigned() == 0x10:
            logger.critical("Test passed control reached at 0x10")
            return

    assert False, "TIMEOUT: PC never reached 0xCC"
    












