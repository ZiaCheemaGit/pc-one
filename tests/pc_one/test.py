import os
import logging
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer,RisingEdge

from python_helper.converter import *

TEST_REGISTRY = {}
LOGGING_ON = os.environ.get("LOGGING_ON") == 1

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
    
    threshold_clk_cycles = 2000

    for i in range(threshold_clk_cycles):

        if LOGGING_ON:
            log_signals(logger, dut)

        await RisingEdge(dut.clk_from_FPGA)

        try:
            if dut.instr_add.value.to_unsigned() == 0xe0:
                if LOGGING_ON:
                    log_signals(logger, dut)
                logger.critical("Test ended control reached at label HALT")

                try: 
                    address = 0x104
                    cell_107 = int(dut.ram_16KB_instance.mem[address + 3].value)
                    cell_106 = int(dut.ram_16KB_instance.mem[address + 2].value)
                    cell_105 = int(dut.ram_16KB_instance.mem[address + 1].value)
                    cell_104 = int(dut.ram_16KB_instance.mem[address].value)
                except:
                    raise Exception("cannot read mem location 0x104 - 0x107")
                
                try:
                    assert "cafebbae" == f"{cell_107:02x}{cell_106:02x}{cell_105:02x}{cell_104:02x}"
                    logger.info("Test Passed")
                    logger.info(f"ram[0x107] = 0x{cell_107: 02x}")
                    logger.info(f"ram[0x106] = 0x{cell_106: 02x}")
                    logger.info(f"ram[0x105] = 0x{cell_105: 02x}")
                    logger.info(f"ram[0x104] = 0x{cell_104: 02x}")
                    logger.info("All these values are set by label PASS")
                except:
                    raise Exception("memory doesnot have values set by label PASS")
                
                return
            
            elif i >= 2000 and dut.instr_add.value.to_unsigned() != 0xe0:
                assert False, "TIMEOUT: PC never reached 0xE09label HALT)"
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

        try:
            address = 0x2000
            cell_0 = int(dut.ram_16KB_instance.mem[address + 3].value)
            cell_1 = int(dut.ram_16KB_instance.mem[address + 2].value)
            cell_2 = int(dut.ram_16KB_instance.mem[address + 1].value)
            cell_3 = int(dut.ram_16KB_instance.mem[address].value)

            result =f"{cell_0:02x}{cell_1:02x}{cell_2:02x}{cell_3:02x}"

            logger.critical("Test ended")
            assert "fffffeee" == result

            logger.critical("Test passed")
            logger.info(f"ram[0x{address}] = {result}")
            logger.info("Test Passed")
            logger.info(f"ram[{address + 3}] = 0x{cell_3: 02x}")
            logger.info(f"ram[{address + 2}] = 0x{cell_2: 02x}")
            logger.info(f"ram[{address + 1}] = 0x{cell_1: 02x}")
            logger.info(f"ram[{address}] = 0x{cell_0: 02x}")
            logger.info("All these values are set g3 variable")

            return
        
        except:
            pass
            
    raise Exception("Threshold cyles passed\nCouldn't read ram[0x2000]")
        

async def uart_tx_monitor(dut, logger):
    try:
        last = int(dut.uart_tx_pin_for_FPGA.value)
        logger.info(f"[UART_MON] initial TX = {last}")

        while True:
            await RisingEdge(dut.clk_from_FPGA)
            cur = int(dut.uart_tx_pin_for_FPGA.value)

            if cur != last:
                t = cocotb.utils.get_sim_time("ns")
                logger.info(f"[UART_MON] {t} ns : TX {last} → {cur}")
                last = cur
    except Exception:
        pass
    
async def wait_for_uart_start(dut, logger, timeout_ns=5_000_000):
    start_time = cocotb.utils.get_sim_time("ns")

    while True:
        await RisingEdge(dut.clk_from_FPGA)

        if int(dut.uart_tx_pin_for_FPGA.value) == 0:
            t = cocotb.utils.get_sim_time("ns")
            logger.info(f"[UART] Start bit detected at {t} ns")
            return t

        now = cocotb.utils.get_sim_time("ns")
        if now - start_time > timeout_ns:
            logger.error(
                f"[UART] TIMEOUT: No start bit after {timeout_ns} ns "
                f"(TX still = {int(dut.uart_tx_pin_for_FPGA.value)})"
            )
            raise cocotb.result.TestFailure("UART never started")

    clk_freq = 50_000_000
    baud = 9600
    baud_period_ns = int(1e9 / baud)

    rx_chars = []

    for _ in range(num_chars):
        # wait for start bit
        while dut.uart_tx_pin_for_FPGA.value == 1:
            await RisingEdge(dut.clk_from_FPGA)

        # middle of start bit
        await Timer(baud_period_ns // 2, unit="ns")

        ch = 0
        for i in range(8):
            await Timer(baud_period_ns, unit="ns")
            ch |= int(dut.uart_tx_pin_for_FPGA.value) << i

        # stop bit
        await Timer(baud_period_ns, unit="ns")

        rx_chars.append(chr(ch))

    return "".join(rx_chars)

async def uart_receive_byte(dut, logger, baud=9600):
    baud_period_ns = int(1e9 / baud)

    await wait_for_uart_start(dut, logger)

    # sample middle of start bit
    await Timer(baud_period_ns // 2, unit="ns")

    value = 0
    for i in range(8):
        if LOGGING_ON:
            log_signals(logger, dut)
        await Timer(baud_period_ns, unit="ns")
        bit = int(dut.uart_tx_pin_for_FPGA.value)
        value |= bit << i
        if LOGGING_ON:
            logger.info(f"[UART] bit[{i}] = {bit}")

    # stop bit
    await Timer(baud_period_ns, unit="ns")
    stop = int(dut.uart_tx_pin_for_FPGA.value)

    if stop != 1:
        logger.error("[UART] STOP BIT ERROR")

    if LOGGING_ON:
        logger.info(f"[UART] Received byte: 0x{value:02X} ('{chr(value)}')")
    return value

@program_test("test_uart_print_c")
async def test_uart_print_c_debug(dut):

    logger = logging.getLogger("uart_debug")
    logger.setLevel(logging.INFO)

    fh = logging.FileHandler("uart_debug.log", mode="w")
    fh.setFormatter(logging.Formatter("%(asctime)s - %(message)s"))
    logger.addHandler(fh)

    # Clock
    cocotb.start_soon(Clock(dut.clk_from_FPGA, 20, unit="ns").start())

    # UART monitor
    cocotb.start_soon(uart_tx_monitor(dut, logger))

    # Reset
    dut.rst_from_FPGA.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_from_FPGA)
    dut.rst_from_FPGA.value = 0
    logger.info("[TEST] Reset released")

    # Wait some time to see if CPU runs at all
    await Timer(1_000, unit="ns")
    logger.info("[TEST] CPU should be running now")

    expected = "Hey!\r\n"
    rx = ""
    for _ in range(len(expected)):
        ch = await uart_receive_byte(dut, logger)
        rx += chr(ch)

    assert rx == expected

    logger.critical(f"[TEST] RECEIVED: {rx}")

