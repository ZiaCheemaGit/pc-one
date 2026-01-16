import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test_uart(dut):
    
    logger = logging.getLogger("test_uart")
