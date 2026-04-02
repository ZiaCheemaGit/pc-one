import logging

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


PROGRAM = {
    0x00000000: 0x00004117,
    0x00000004: 0x00010113,
    0x00000008: 0x15000293,
    0x0000000c: 0x00002317,
    0x00000010: 0xff430313,
    0x00000014: 0x00002397,
    0x00000018: 0xfec38393,
    0x0000001c: 0x00730c63,
    0x00000020: 0x0002ae03,
    0x00000024: 0x01c32023,
    0x00000028: 0x00428293,
    0x0000002c: 0x00430313,
    0x00000030: 0xfedff06f,
    0x00000034: 0x00002297,
    0x00000038: 0xfcc28293,
    0x0000003c: 0x00002317,
    0x00000040: 0xfc430313,
    0x00000044: 0x00628863,
    0x00000048: 0x0002a023,
    0x0000004c: 0x00428293,
    0x00000050: 0xff5ff06f,
    0x00000054: 0x008000ef,
    0x00000058: 0x0000006f,
    0x0000005c: 0xff010113,
    0x00000060: 0x14c00513,
    0x00000064: 0x00112623,
    0x00000068: 0x034000ef,
    0x0000006c: 0x0000006f,
    0x00000070: 0x00004737,
    0x00000074: 0x00472783,
    0x00000078: 0x00470713,
    0x0000007c: 0x0017f793,
    0x00000080: 0x00078863,
    0x00000084: 0x00072783,
    0x00000088: 0x0017f793,
    0x0000008c: 0xfe079ce3,
    0x00000090: 0x000047b7,
    0x00000094: 0x00a7a023,
    0x00000098: 0x00008067,
    0x0000009c: 0x00054683,
    0x000000a0: 0x02068c63,
    0x000000a4: 0x00004737,
    0x000000a8: 0x00470713,
    0x000000ac: 0x00004637,
    0x000000b0: 0x00072783,
    0x000000b4: 0x00150513,
    0x000000b8: 0x0017f793,
    0x000000bc: 0x00078863,
    0x000000c0: 0x00072783,
    0x000000c4: 0x0017f793,
    0x000000c8: 0xfe079ce3,
    0x000000cc: 0x00d62023,
    0x000000d0: 0x00054683,
    0x000000d4: 0xfc069ee3,
    0x000000d8: 0x00008067,
}


def instruction_fetch(addr):
    return PROGRAM.get(addr, 0x00000013)


DATA_MEM = {}


def data_mem_read(addr):
    return DATA_MEM.get(addr, 0)


def data_mem_write(addr, data):
    DATA_MEM[addr] = data


@cocotb.test()
async def test_core_program(dut):
    logger = logging.getLogger("test_core")
    clock = Clock(dut.clk, 10, unit="ns")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1

    dut.instruction.value = 0
    dut.mem_data_from_mem.value = 0

    await RisingEdge(dut.clk)
    dut.rst.value = 0

    for cycle in range(2000):
        await RisingEdge(dut.clk)

        pc = int(dut.instruction_address.value)
        if pc == 0x6c:
            logger.critical("Program reached End")
            break
        else:
            logger.critical(f"PC = 0x{pc:08x}")

        dut.instruction.value = instruction_fetch(pc)

        if dut.mem_write.value == 1:
            addr = int(dut.mem_address.value)
            data = int(dut.mem_data_to_mem.value)
            data_mem_write(addr, data)
            logger.info(
                f"STORE addr={hex(addr)} data={hex(data)}"
            )

        if dut.mem_read.value == 1:
            addr = int(dut.mem_address.value)
            read_data = data_mem_read(addr)
            dut.mem_data_from_mem.value = read_data
            logger.info(
                f"LOAD addr={hex(addr)} -> {hex(read_data)}"
            )



