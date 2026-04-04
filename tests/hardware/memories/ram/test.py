import os
import logging
import sys

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

sys.path.append(os.path.abspath("../../../../"))
from python_helper.converter import *
from python_helper.logging import log_signals_pc_one_sync

LOGGING_ON = os.environ.get("LOGGING_ON") == "1"


@cocotb.test()
async def test_ram(dut):
    test_name = "test_ram"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    await RisingEdge(dut.clk)
    data_out = 0

    # Word Aligned LOAD and STORE
    # store 
    dut.data_address.value = 0x2000
    dut.mem_read.value = 0
    dut.mem_write.value = 1
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.data_in.value = 0x00000036
    await RisingEdge(dut.clk)
    data_out = dut.data_out.value.to_unsigned()
    logger.info(f"data_out = 0x{data_out:08x}")

    # load
    dut.data_address.value = 0x2000
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = 1
    dut.half_op.value = 0
    dut.data_in.value = 0
    await RisingEdge(dut.clk)
    data_out = dut.data_out.value.to_unsigned()
    logger.info(f"data_out = {data_out}")

    assert data_out == 0x36
    logger.critical(f"Word Aligned Test Passed - read data = expected value 0x{data_out:08x}")

    # # store 
    # dut.data_address.value = 0x27f7
    # dut.mem_read.value = 0
    # dut.mem_write.value = 1
    # dut.byte_op.value = 1
    # dut.half_op.value = 0
    # dut.data_in.value = 0x36
    # await RisingEdge(dut.clk)
    # data_out = dut.data_out.value.to_unsigned()
    # logger.info(f"data_out = 0x{data_out:08x}")

    # # load
    # dut.data_address.value = 0x27f7
    # dut.mem_read.value = 1
    # dut.mem_write.value = 0
    # dut.byte_op.value = 1
    # dut.half_op.value = 0
    # dut.data_in.value = 0
    # await RisingEdge(dut.clk)
    # data_out = dut.data_out.value
    # logger.info(f"data_out = {data_out}")

    # assert data_out == 0x36
    # logger.critical(f"Word Unaligned Test Passed - read data = expected value {data_out:08x}")

