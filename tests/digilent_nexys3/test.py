import os
import logging

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from python_helper.converter import *
from python_helper.uart_terminal import UARTTerminal

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


@cocotb.test()
async def test_uart_terminal_display(dut):

    CLK_FREQ_HZ = 100_000_000
    CLK_PERIOD_NS = 1e9 / CLK_FREQ_HZ
    BAUD_RATE = 9600
    UART_FREQ_HZ = 1_000_000
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

    print(f"\n===== UART TERMINAL START(CLK_FREQ_HZ = {CLK_FREQ_HZ}, BAUD_RATE = {BAUD_RATE}) =====\n")

    # UART terminal (minicom-equivalent)
    term = UARTTerminal(
        LOGGING_ON,
        logger,
        dut=dut,
        tx=dut.uart_tx_pin_for_FPGA,
        baud_clks=BAUD_CLKS,
        clk_period_ns=UART_CLK_PERIOD_NS,
        echo=True
    )

    await term.run()

