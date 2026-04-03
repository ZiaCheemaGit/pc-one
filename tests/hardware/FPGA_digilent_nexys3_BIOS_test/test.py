import os
import logging
import sys
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer, RisingEdge

sys.path.append(os.path.abspath("../../../"))
from python_helper.converter import *
from python_helper.uart_terminal import UARTTerminal, UARTDriver
from python_helper.logging import log_signals_pc_one

LOGGING_ON = os.environ.get("LOGGING_ON") == "1"

@cocotb.test()
async def test_uart_terminal_display(dut):

    CLK_FREQ_HZ = 100_000_000
    CLK_PERIOD_NS = 1e9 / CLK_FREQ_HZ
    BAUD_RATE = 9600
    UART_FREQ_HZ = 25_000_000
    UART_CLK_PERIOD_NS = 1e9 / UART_FREQ_HZ
    BAUD_CLKS = int(UART_FREQ_HZ / BAUD_RATE)

    test_name = "uart_terminal_display"
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
    await RisingEdge(dut.clk_from_FPGA)

    print(f"\n===== UART TERMINAL START(CLK_FREQ_HZ = {CLK_FREQ_HZ}, BAUD_RATE = {BAUD_RATE}) =====\n")
    terminal = UARTTerminal(
        100_000,
        LOGGING_ON,
        logger,
        dut=dut,
        tx=dut.uart_tx_pin_for_FPGA,
        baud_clks=BAUD_CLKS,
        clk_period_ns=UART_CLK_PERIOD_NS
    )

    if LOGGING_ON:
        cocotb.start_soon(log_signals_pc_one(logger, dut.pc_one_instance))

    buffer = await terminal.run()

    expected_string = "Hey!\r\n"

    if expected_string != buffer:
            raise Exception(f"Expected = {expected_string}, Received = {buffer}")
    else:
        logger.info(f"Expected = {expected_string}, Received = {buffer} UART Test Passed")
    


