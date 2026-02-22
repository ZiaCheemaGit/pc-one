import sys
import os
import logging

import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock

sys.path.append(os.path.abspath("../../"))
from python_helper.vga import *


@cocotb.test()
async def test_vga(dut):

    CLK_FREQ = 25
    CLK_FREQ_MHz = CLK_FREQ * 1_000_000
    CLK_PERIOD_NS = 1e9 / CLK_FREQ_MHz

    dut.pixel_data.value = 5

    # start clock
    cocotb.start_soon(Clock(dut.clk_25MHz, CLK_PERIOD_NS, unit="ns").start())
    dut.reset.value = 1
    for _ in range(5):
        await RisingEdge(dut.clk_25MHz)
    dut.reset.value = 0

    monitor = VGAMonitor()
    logger = logging.getLogger("VGA")

    while True:
        await RisingEdge(dut.clk_25MHz)

        r  = int(dut.red.value)   * 255
        g  = int(dut.green.value) * 255
        b  = int(dut.blue.value)  * 255
        hs = int(dut.hsync.value)
        vs = int(dut.vsync.value)

        monitor.handle_events()

        vga_cable = VGA_CABLE(
            r,
            g,
            b,
            hs,
            vs,
            CLK_FREQ
        )

        monitor.update_display(vga_cable)
