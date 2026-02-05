import logging
import random
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


CLK_FREQ = 50_000_000
BAUD = 9600
BAUD_PERIOD_NS = int(1e9 / BAUD)
CLK_PERIOD_NS = 20


async def uart_receive_frame(dut):
    """
    Software UART receiver:
    - waits for start bit
    - samples in middle of each bit
    - returns received byte
    """

    # Wait for start bit (tx goes low)
    while dut.tx.value == 1:
        await RisingEdge(dut.clk)

    # Move to middle of start bit
    await Timer(BAUD_PERIOD_NS // 2, unit="ns")

    assert dut.tx.value == 0, "Invalid start bit"

    rx_byte = 0

    # Sample 8 data bits (LSB first)
    for i in range(8):
        await Timer(BAUD_PERIOD_NS, unit="ns")
        rx_byte |= int(dut.tx.value) << i

    # Stop bit
    await Timer(BAUD_PERIOD_NS, unit="ns")
    assert dut.tx.value == 1, "Stop bit not detected"

    return rx_byte


@cocotb.test()
async def test_uart_hard(dut):
    logger = logging.getLogger("UART_HARD_TEST")

    # Clock
    cocotb.start_soon(Clock(dut.clk, CLK_PERIOD_NS, unit="ns").start())

    # Reset
    dut.rst.value = 1
    dut.write_en.value = 0
    dut.data.value = 0
    await Timer(100, unit="ns")
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Post-reset sanity
    assert dut.tx.value == 1, "TX not idle after reset"
    assert dut.uart_busy.value == 0, "UART busy after reset"

    NUM_FRAMES = 10
    tx_bytes = [random.randint(0, 255) for _ in range(NUM_FRAMES)]
    rx_bytes = []

    for idx, byte in enumerate(tx_bytes):
        logger.info(f"Transmitting frame {idx}: 0x{byte:02X}")

        # Start transmit
        dut.data.value = byte
        dut.write_en.value = 1
        await RisingEdge(dut.clk)
        dut.write_en.value = 0

        # Busy must assert
        await RisingEdge(dut.clk)
        assert dut.uart_busy.value == 1, "uart_busy not asserted"

        # Illegal write during busy (must be ignored)
        dut.data.value = random.randint(0, 255)
        dut.write_en.value = 1
        await RisingEdge(dut.clk)
        dut.write_en.value = 0

        # Receive UART frame
        rx = await uart_receive_frame(dut)
        rx_bytes.append(rx)

        # Busy must clear after frame
        await Timer(BAUD_PERIOD_NS, unit="ns")
        assert dut.uart_busy.value == 0, "uart_busy did not clear"
        assert dut.tx.value == 1, "TX not idle after frame"

    logger.info(f"TX bytes: {[hex(b) for b in tx_bytes]}")
    logger.info(f"RX bytes: {[hex(b) for b in rx_bytes]}")

    assert rx_bytes == tx_bytes, "UART multi-frame data mismatch!"

    logger.info("HARD UART TX TEST PASSED")
