import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock
import logging

@cocotb.test()
async def test_rom(dut):
    """Basic instruction fetch + data read/write test"""
    logger = logging.getLogger("test_rom")
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    Timer(20, "ns")

    for pc in range(0x134):
        dut.pc.value = pc
        await RisingEdge(dut.clk)
        
        try:
            logger.critical(f"PC = {pc: 03x} instruction = {int(dut.instruction.value): 08x}")
        except Exception:
            logger.critical(f"PC = {pc: 03x} instruction = Cannot read Instruction Value")


