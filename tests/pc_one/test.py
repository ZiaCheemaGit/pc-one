import os
import logging

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from python_helper.converter import *
from python_helper.uart_terminal import UARTTerminal


TEST_REGISTRY = {}
LOGGING_ON = os.environ.get("LOGGING_ON") == "1"


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
            logger.info(f"mem_write = {dut.ram_instance.mem_write.value.to_unsigned()}")
        except Exception:
            logger.info(f"mem_write = {dut.ram_instance.mem_write.value}")

        # data_in
        try: 
            logger.info(f"data_in = {dut.ram_instance.data_in.value.to_unsigned()}")
        except Exception:
            logger.info(f"data_in = {dut.ram_instance.data_in.value}")

        # mem_read
        try: 
            logger.info(f"mem_read = {dut.ram_instance.mem_read.value.to_unsigned()}")
        except Exception:
            logger.info(f"mem_read = {dut.ram_instance.mem_read.value}")

        # data_out
        try: 
            logger.info(f"data_out = {dut.ram_instance.data_out.value.to_unsigned()}")
        except Exception:
            logger.info(f"data_out = {dut.ram_instance.data_out.value}")

        # data_address
        try: 
            logger.info(f"data_address = {dut.ram_instance.data_address.value.to_unsigned()}")
        except Exception:
            logger.info(f"data_address = {dut.ram_instance.data_address.value}")


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
            log_signals(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)
        try:
            if dut.rom_instance.pc.value.to_unsigned() == 0x12c:
                logger.critical("Test ended control reached at label HALT")
                await RisingEdge(dut.clk_from_FPGA)
                try: 
                    address = 0x2104
                    word_index = address >> 2
                    cell_2104 = int(dut.ram_instance.mem[word_index].value)
                except:
                    raise Exception("cannot read mem location 0x2104")
                
                try:
                    PASS = 0xCAFEBBAE
                    FAIL = 0xDEADBEEF
                    assert cell_2104 == PASS, f"Expected PASS, got 0x{cell_2104:08x}"
                    logger.info("Test Passed")
                    logger.info(f"ram[0x104] = 0x{cell_2104: 02x}")
                    logger.info("Value is Correctly set by label PASS")
                except:
                    raise Exception("memory doesnot have values set by label PASS")
                
                return
            
            elif i >= (threshold_clk_cycles - 1) and dut.instr_add.value.to_unsigned() != 0xe0:
                assert False, "TIMEOUT: PC never reached label HALT)"
            
        except:
            raise Exception("cannot read PC value")

    
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
            log_signals(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)
        
        address = 0x2000
        
        if dut.rom_instance.pc.value.to_unsigned() == 0x58:
            logger.critical("Test ended PC reached 0x58")
            word_index = address >> 2
            cell_3 = int(dut.ram_instance.mem[word_index].value)

            result =f"{cell_3:08x}"

            assert "fffffeee" == result

            logger.critical("Test passed")
            logger.info(f"ram[0x{address}] = {result}")
            logger.info("Test Passed")
            logger.info("g3 variable value is correctly calculated")
            
            return
        
    raise Exception("Threshold cyles passed\nPC never reached end")


@program_test("test_uart_print_c")
async def test_uart_terminal_display(dut):

    CLK_FREQ_HZ = 100_000_000
    CLK_PERIOD_NS = 1e9 / CLK_FREQ_HZ
    BAUD_RATE = 115200
    BAUD_CLKS = int(CLK_FREQ_HZ / BAUD_RATE)

    test_name = "test_math_c"
    logger = logging.getLogger(test_name)
    file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
    formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)
    logger.setLevel(logging.INFO)

    # start clock
    cocotb.start_soon(Clock(dut.clk_from_FPGA, CLK_PERIOD_NS, unit="ns").start())

    # reset
    dut.rst_from_FPGA.value = 1
    for _ in range(10):
        await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0

    print("\n===== UART TERMINAL START =====\n")

    # UART terminal (minicom-equivalent)
    term = UARTTerminal(
        LOGGING_ON,
        logger,
        dut=dut,
        tx=dut.uart_tx_pin_for_FPGA,
        baud_clks=BAUD_CLKS,
        clk_period_ns=CLK_PERIOD_NS,
        echo=True
    )

    await term.run()

