import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random

import os
import logging

LOGGING_ON = os.environ.get("LOGGING_ON") == "1"

# -----------------------------------------------------------------------------
# Helper Coroutines
# -----------------------------------------------------------------------------

async def reset_dut(dut):
    """Initialize all inputs to zero."""
    dut.data_address.value = 0
    dut.mem_read.value = 0
    dut.mem_write.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.data_in.value = 0
    
    # Wait a couple of clock cycles
    for _ in range(2):
        await RisingEdge(dut.clk)

async def write_memory(dut, addr, data, byte_op=0, half_op=0):
    """Drives the bus to write data to the RAM."""
    dut.data_address.value = addr
    dut.data_in.value = data
    dut.mem_write.value = 1
    dut.mem_read.value = 0
    dut.byte_op.value = byte_op
    dut.half_op.value = half_op
    
    await RisingEdge(dut.clk)
    
    # De-assert
    dut.mem_write.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0

async def read_memory(dut, addr, byte_op=0, half_op=0):
    """Drives the bus to read data, waits one cycle, and returns the result."""
    dut.data_address.value = addr
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = byte_op
    dut.half_op.value = half_op
    
    await RisingEdge(dut.clk)
    
    # De-assert and capture data on the next cycle
    dut.mem_read.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0
    
    return dut.data_out.value.to_unsigned()

# -----------------------------------------------------------------------------
# Test Cases
# -----------------------------------------------------------------------------

@cocotb.test()
async def test_word_access(dut):
    """Test standard 32-bit word writes and reads (sw / lw)."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset_dut(dut)

    test_addr = 0x2100
    test_data = 0xDEADBEEF

    await write_memory(dut, test_addr, test_data, byte_op=0, half_op=0)
    read_val = await read_memory(dut, test_addr, byte_op=0, half_op=0)

    assert read_val == test_data, f"Word mismatch! Expected {hex(test_data)}, got {hex(read_val)}"


@cocotb.test()
async def test_byte_isolation(dut):
    """
    Test independent byte writes (sb). 
    This guarantees that writing a char in C won't overwrite adjacent string data.
    """
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset_dut(dut)

    base_addr = 0x2000
    
    # First, clear the entire word to 0x00000000
    await write_memory(dut, base_addr, 0x00000000, byte_op=0, half_op=0)

    # Write 4 independent bytes to offsets 0, 1, 2, 3
    # Note: Depending on your architecture's endianness, you may need to shift the data_in
    # For this test, we assume the CPU aligns the byte to the correct position on the data_in bus,
    # OR your RAM handles the alignment internally based on data_address[1:0].
    # Assuming RAM expects the byte in the lower 8 bits for all byte ops:
    
    await write_memory(dut, base_addr + 0, 0xAA, byte_op=1, half_op=0)
    await write_memory(dut, base_addr + 1, 0xBB, byte_op=1, half_op=0)
    await write_memory(dut, base_addr + 2, 0xCC, byte_op=1, half_op=0)
    await write_memory(dut, base_addr + 3, 0xDD, byte_op=1, half_op=0)

    # Read the full word back
    full_word = await read_memory(dut, base_addr, byte_op=0, half_op=0)

    # Assuming Little Endian (RISC-V standard) -> 0xDDCCBBAA
    expected_word = 0xDDCCBBAA
    assert full_word == expected_word, f"Byte isolation failed! Expected {hex(expected_word)}, got {hex(full_word)}"


@cocotb.test()
async def test_halfword_isolation(dut):
    """Test independent halfword writes (sh)."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset_dut(dut)

    base_addr = 0x3000
    
    # Clear the word
    await write_memory(dut, base_addr, 0x00000000, byte_op=0, half_op=0)

    # Write two halfwords
    await write_memory(dut, base_addr + 0, 0xBEEF, byte_op=0, half_op=1)
    await write_memory(dut, base_addr + 2, 0xDEAD, byte_op=0, half_op=1)

    # Read the full word back
    full_word = await read_memory(dut, base_addr, byte_op=0, half_op=0)

    expected_word = 0xDEADBEEF
    assert full_word == expected_word, f"Halfword isolation failed! Expected {hex(expected_word)}, got {hex(full_word)}"


@cocotb.test()
async def test_random_fuzzing(dut):
    """Throw random data at random aligned addresses to ensure stability."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset_dut(dut)

    memory_model = {}

    # Write phase
    for _ in range(50):
        # Generate a random 4-byte aligned address between 0x0 and 0x4000
        addr = random.randrange(0x2000, 0x6000, 4)
        data = random.randint(0, 0xFFFFFFFF)
        
        memory_model[addr] = data
        await write_memory(dut, addr, data, byte_op=0, half_op=0)

    # Read phase
    for addr, expected_data in memory_model.items():
        read_val = await read_memory(dut, addr, byte_op=0, half_op=0)
        assert read_val == expected_data, f"Fuzz test failed at {hex(addr)}. Expected {hex(expected_data)}, got {hex(read_val)}"

@cocotb.test()
async def test_ram_word_aligned(dut):
    test_name = "test_ram_word_aligned"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    test_data = 0xFFCDAB36
    await RisingEdge(dut.clk)
    data_out = 0

    # Word Aligned LOAD and STORE
    # store 
    dut.data_address.value = 0x2000
    dut.mem_read.value = 0
    dut.mem_write.value = 1
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.data_in.value = test_data
    await RisingEdge(dut.clk)
    data_out = dut.data_out.value.to_unsigned()
    logger.info(f"data_out = 0x{data_out:08x}")

    # load
    dut.data_address.value = 0x2000
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = 0
    dut.half_op.value = 0
    dut.data_in.value = 0
    await RisingEdge(dut.clk)
    data_out = dut.data_out.value.to_unsigned()
    logger.info(f"data_out = {data_out}")

    assert data_out == test_data
    logger.critical(f"Word Aligned Test Passed")
    logger.critical(f"Expected value: 0x{test_data:08x}   Received: 0x{data_out:08x}")


@cocotb.test()
async def test_ram_word_non_aligned(dut):
    test_name = "test_ram_word_non_aligned"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    test_data = 0x00000036
    await RisingEdge(dut.clk)
    data_out = 0

    # Non Word Aligned LOAD and STORE
    # store 
    dut.data_address.value = 0x27f4
    dut.mem_read.value = 0
    dut.mem_write.value = 1
    dut.byte_op.value = 1
    dut.half_op.value = 0
    dut.data_in.value = test_data
    await RisingEdge(dut.clk)
    data_out = dut.data_out.value.to_unsigned()
    logger.info(f"data_out = 0x{data_out:08x}")

    # load
    dut.data_address.value = 0x27f7
    dut.mem_read.value = 1
    dut.mem_write.value = 0
    dut.byte_op.value = 1
    dut.half_op.value = 0
    dut.data_in.value = 0
    await RisingEdge(dut.clk)
    data_out = dut.data_out.value.to_unsigned()
    logger.info(f"data_out = {data_out}")

    assert data_out == 0x36
    logger.critical(f"Non Word Aligned Test Passed")
    logger.critical(f"Expected value: 0x{test_data:08x}   Received: {data_out:08x}")

