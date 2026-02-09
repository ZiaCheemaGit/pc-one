import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from uart_terminal import UARTTerminal

BAUD_CLKS = 868   # MUST match uart_tx.v
CLK_PERIOD_NS = 10

@cocotb.test()
async def test_uart_terminal_display(dut):

    # start clock
    cocotb.start_soon(
        Clock(dut.clk_100MHz, CLK_PERIOD_NS, unit="ns").start()
    )

    # reset
    dut.rst.value = 1
    for _ in range(10):
        await RisingEdge(dut.clk_100MHz)
    dut.rst.value = 0

    print("\n===== UART TERMINAL START =====\n")

    # UART terminal (minicom-equivalent)
    term = UARTTerminal(
        dut=dut,
        tx=dut.uart_tx,
        baud_clks=BAUD_CLKS,
        clk_period_ns=CLK_PERIOD_NS,
        echo=True
    )

    await term.run()
