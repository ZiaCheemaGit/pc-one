import logging
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test_rom(dut):
    test_name = "test_rom"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())

    for i in range(0x128):
        dut.pc.value = i

        await RisingEdge(dut.clk)  
        try:
            instr = int(dut.instruction.value)
            logger.critical(f"PC=0x{i:08x} INSTR=0x{instr:08x}")
        except Exception:
            instr = dut.instruction
            logger.critical(f"PC=0x{i:08x} INSTR=0x{instr}")

