import os

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


LOGGING_ON = os.environ.get("LOGGING_ON") == "1"


async def write_word(dut, addr, data):
    dut.data_address.value = addr
    dut.data_in.value = data
    dut.mem_write.value = 1
    dut.mem_read.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.unsigned_op.value = 0

    await RisingEdge(dut.clk)
    dut.mem_write.value = 0


async def read_word(dut, addr):
    dut.data_address.value = addr
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.unsigned_op.value = 0

    await Timer(1, unit="ns")
    return int(dut.data_out.value)


async def write_byte(dut, addr, data):
    dut.data_address.value = addr
    dut.data_in.value = data
    dut.mem_write.value = 1
    dut.mem_read.value = 0
    dut.byte_op.value = 1
    dut.half_op.value = 0

    await RisingEdge(dut.clk)
    dut.mem_write.value = 0


async def read_byte(dut, addr, unsigned=True):
    dut.data_address.value = addr
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = 1
    dut.half_op.value = 0
    dut.unsigned_op.value = 1 if unsigned else 0

    await Timer(1, unit="ns")
    return int(dut.data_out.value)


async def write_half(dut, addr, data):
    dut.data_address.value = addr
    dut.data_in.value = data
    dut.mem_write.value = 1
    dut.mem_read.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 1

    await RisingEdge(dut.clk)
    dut.mem_write.value = 0


async def read_half(dut, addr, unsigned=True):
    dut.data_address.value = addr
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 1
    dut.unsigned_op.value = 1 if unsigned else 0

    await Timer(1, unit="ns")
    return int(dut.data_out.value)


@cocotb.test()
async def test_ram(dut):

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.mem_read.value = 0
    dut.mem_write.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.unsigned_op.value = 0
    dut.data_address.value = 0
    dut.data_in.value = 0

    await RisingEdge(dut.clk)

    base_addr = 0x00000020

    # WORD WRITE / READ
    test_word = 0xAABBCCDD
    await write_word(dut, base_addr, test_word)
    result = await read_word(dut, base_addr)

    assert result == test_word, \
        f"Word mismatch: expected {hex(test_word)}, got {hex(result)}"


    # BYTE WRITE / READ
    await write_word(dut, base_addr, 0x00000000)

    await write_byte(dut, base_addr + 0, 0x11)
    await write_byte(dut, base_addr + 1, 0x22)
    await write_byte(dut, base_addr + 2, 0x33)
    await write_byte(dut, base_addr + 3, 0x44)

    result = await read_word(dut, base_addr)

    assert result == 0x44332211, \
        f"Byte write failed: got {hex(result)}"


    # HALFWORD WRITE / READ
    await write_word(dut, base_addr, 0x00000000)

    await write_half(dut, base_addr + 0, 0xABCD)
    await write_half(dut, base_addr + 2, 0x1234)

    result = await read_word(dut, base_addr)

    assert result == 0x1234ABCD, \
        f"Halfword write failed: got {hex(result)}"


    # SIGNED BYTE LOAD
    await write_word(dut, base_addr, 0x000000FF)

    result = await read_byte(dut, base_addr, unsigned=False)

    assert result == 0xFFFFFFFF, \
        f"Signed byte extension failed: got {hex(result)}"


    # UNSIGNED BYTE LOAD
    result = await read_byte(dut, base_addr, unsigned=True)

    assert result == 0x000000FF, \
        f"Unsigned byte extension failed: got {hex(result)}"


    if LOGGING_ON:
        dut._log.info("RAM test completed successfully")