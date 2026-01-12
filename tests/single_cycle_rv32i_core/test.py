"""

module top(
    input clk,
    input rst
    );

"""

import os
import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from instr_format.converter import *

def log_signals(logger, dut):
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
    
    threshold_clk_cycles = 2000
    LOGGING_ON = os.environ.get("LOGGING_ON") == 1

    for i in range(threshold_clk_cycles):

        if LOGGING_ON:
            log_signals(logger, dut)

        await RisingEdge(dut.clk)

        try:
            if dut.instr_add.value.to_unsigned() == 0xe0:
                if LOGGING_ON:
                    log_signals(logger, dut)
                logger.critical("Test ended control reached at label HALT")

                try: 
                    cell_104 = int(dut.ram_16KB_instance.mem[0x104].value)
                    cell_105 = int(dut.ram_16KB_instance.mem[0x105].value)
                    cell_106 = int(dut.ram_16KB_instance.mem[0x106].value)
                    cell_107 = int(dut.ram_16KB_instance.mem[0x107].value)
                except:
                    raise Exception("cannot read mem location 0x104 - 0x107")
                
                try:
                    assert "cafebbae" == f"{cell_107:02x}{cell_106:02x}{cell_105:02x}{cell_104:02x}"
                    logger.info("Test Passed")
                    logger.info(f"mem[0x107] = 0x{cell_107: 02x}")
                    logger.info(f"mem[0x106] = 0x{cell_106: 02x}")
                    logger.info(f"mem[0x105] = 0x{cell_105: 02x}")
                    logger.info(f"mem[0x104] = 0x{cell_104: 02x}")
                    logger.info("All these values are set by label PASS")
                except:
                    raise Exception("memory doesnot have values set by label PASS")
                
                return
            
            elif i >= 2000 and dut.instr_add.value.to_unsigned() != 0xe0:
                assert False, "TIMEOUT: PC never reached 0xE09label HALT)"
        except:
            raise Exception("cannot read PC value")

    


