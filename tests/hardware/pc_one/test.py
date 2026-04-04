import os
import logging
import sys

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

sys.path.append(os.path.abspath("../../../"))
from python_helper.converter import *
from python_helper.logging import log_signals_pc_one_sync

TEST_REGISTRY = {}
LOGGING_ON = os.environ.get("LOGGING_ON") == "1"


def program_test(name):
    def decorator(func):
        TEST_REGISTRY[name] = func
        return func
    return decorator


@cocotb.test()
async def run_program_test(dut):
    program_file = os.environ["PROGRAM_FILE"]
    program_name = os.path.basename(program_file).replace(".hex", "")

    dut._log.info(f"Loaded program: {program_name}")

    if program_name not in TEST_REGISTRY:
        raise RuntimeError(f"No cocotb test registered for program '{program_name}'")

    await TEST_REGISTRY[program_name](dut)


@program_test("test_basic_asm")
async def test_basic_asm(dut):

    test_name = "test_basic_asm"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk_from_FPGA, 1, unit="ns").start()) 

    # reset cpu 
    dut.rst_from_FPGA.value = 1
    await RisingEdge(dut.clk_from_FPGA)
    await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0
    await RisingEdge(dut.clk_from_FPGA)

    logger.info("Reset released. CPU starting execution.")
    logger.info("Starting test_basic_asm")
    
    threshold_clk_cycles = 2000

    for i in range(threshold_clk_cycles):
        if LOGGING_ON:
            log_signals_pc_one_sync(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)

        if dut.boot_rom_instance.pc.value.to_unsigned() == 0x130:
            logger.critical("Test ended control reached at label HALT")
            await RisingEdge(dut.clk_from_FPGA)

            result = int(dut.core_instance.reg_file_instance.registers[1].value)
            assert result == 0xCAFEBBAE, f"Expected PASS, got 0x{result:08x}"
            logger.info("Test Passed")
            logger.info(f"result = 0x{result:08x}")
            logger.info("Value is Correctly set by label PASS")
            
            return
        
        elif i >= (threshold_clk_cycles - 1) and dut.instr_add.value.to_unsigned() != 0xe0:
            assert False, "TIMEOUT: PC never reached label HALT)"


@program_test("test_load_asm")
async def test_load_asm(dut):
    test_name = "test_load_asm"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk_from_FPGA, 1, unit="ns").start()) 

    # reset cpu 
    dut.rst_from_FPGA.value = 1
    await RisingEdge(dut.clk_from_FPGA)
    await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0
    await RisingEdge(dut.clk_from_FPGA)

    logger.info("Reset released. CPU starting execution.")
    
    threshold_clk_cycles = 2000
    test_ended = False

    for _ in range(threshold_clk_cycles):
        if LOGGING_ON:
            log_signals_pc_one_sync(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)
        
        if dut.boot_rom_instance.pc.value.to_unsigned() == 0x88:
            await RisingEdge(dut.clk_from_FPGA)
            await RisingEdge(dut.clk_from_FPGA)
            logger.critical("Test Ended")
            test_ended = True
            
            reg_10 = dut.core_instance.reg_file_instance.registers[10].value
            reg_11 = dut.core_instance.reg_file_instance.registers[11].value
            reg_12 = dut.core_instance.reg_file_instance.registers[12].value
            reg_13 = dut.core_instance.reg_file_instance.registers[13].value
            reg_14 = dut.core_instance.reg_file_instance.registers[14].value

            assert int(reg_10) == 0xAABBCCDD
            assert int(reg_11) == 0xFFFFCCDD
            assert int(reg_12) == 0xFFFFFFDD
            assert int(reg_13) == 0x000000DD
            assert int(reg_14) == 0x0000CCDD
            
            break
    
    if not test_ended:
        assert False, "Test Ended Abnormally"


@program_test("test_load_neg_asm")
async def test_load_neg_asm(dut):
    test_name = "test_load_neg_asm"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk_from_FPGA, 1, unit="ns").start()) 

    # reset cpu 
    dut.rst_from_FPGA.value = 1
    await RisingEdge(dut.clk_from_FPGA)
    await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0
    await RisingEdge(dut.clk_from_FPGA)

    logger.info("Reset released. CPU starting execution.")
    
    threshold_clk_cycles = 2000
    test_ended = False

    for _ in range(threshold_clk_cycles):
        if LOGGING_ON:
            log_signals_pc_one_sync(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)
        
        if dut.boot_rom_instance.pc.value.to_unsigned() == 0xa8:
            await RisingEdge(dut.clk_from_FPGA)
            await RisingEdge(dut.clk_from_FPGA)
            logger.critical("Test Ended")
            test_ended = True
            
            reg_1 = dut.core_instance.reg_file_instance.registers[1].value
            logger.critical(f"reg1 = {int(reg_1):08x}")
            assert int(reg_1) == 0xCAFEBBAE
            logger.critical("Test Passed")
            break
    
    if not test_ended:
        assert False, "Test Ended Abnormally"


@program_test("test_math_c")
async def test_math_c(dut):
    
    test_name = "test_math_c"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk_from_FPGA, 1, unit="ns").start()) 

    # reset cpu 
    dut.rst_from_FPGA.value = 1
    await RisingEdge(dut.clk_from_FPGA)
    await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0
    await RisingEdge(dut.clk_from_FPGA)

    logger.info("Reset released. CPU starting execution.")
    
    threshold_clk_cycles = 2000

    for _ in range(threshold_clk_cycles):

        if LOGGING_ON:
            log_signals_pc_one_sync(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)
        
        address = 0x0
        
        if dut.boot_rom_instance.pc.value.to_unsigned() == 0x58:
            logger.critical("Test ended PC reached 0x58")
            word_index = address >> 2
            result = dut.ram_instance.mem[word_index].value.to_unsigned()

            assert 0xfffffeee == result

            logger.critical("Test passed")
            logger.info(f"ram[0x{address}] = {result}")
            logger.info("Test Passed")
            logger.info("g3 variable value is correctly calculated")
            
            return
        
    raise Exception("Threshold cyles passed\nPC never reached end")


@program_test("test_aggressive_c")
async def test_aggressive_c(dut):
    
    test_name = "test_aggressive_c"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # run clock concurrently
    cocotb.start_soon(Clock(dut.clk_from_FPGA, 1, unit="ns").start()) 

    # reset cpu 
    dut.rst_from_FPGA.value = 1
    await RisingEdge(dut.clk_from_FPGA)
    await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0
    await RisingEdge(dut.clk_from_FPGA)

    logger.info("Reset released. CPU starting execution.")
    
    threshold_clk_cycles = 2000

    for _ in range(threshold_clk_cycles):

        if LOGGING_ON:
            log_signals_pc_one_sync(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)
        
        address = 0x0
        
        if dut.boot_rom_instance.pc.value.to_unsigned() == 0x58:
            logger.critical("Test ended PC reached 0x58")
            word_index = address >> 2
            result = dut.ram_instance.mem[word_index].value.to_unsigned()

            assert 0xaaaaaaaa == result

            logger.critical("Test passed")
            logger.info(f"ram[0x{address}] = {result}")
            logger.info("Test Passed")
            
            return
        
    raise Exception("Threshold cyles passed\nPC never reached end")

