import logging

from cocotb.triggers import Timer
import cocotb

class UARTTerminal:
    """
    UART terminal emulator (8N1) with ZERO drift.
    Matches FPGA + minicom exactly.
    """

    def __init__(self, dut, tx, baud_clks, clk_period_ns=10, echo=True):
        self.dut = dut
        self.tx = tx
        self.echo = echo

        self.bit_time_ns = baud_clks * clk_period_ns
        self.half_bit_ns = self.bit_time_ns // 2

        self.buffer = ""

    async def receive_byte(self):
        """Receive one UART byte using real-time sampling"""

        # wait for start bit
        while int(self.tx.value) == 1:
            await Timer(1, unit="ns")

        # move to middle of start bit
        await Timer(self.half_bit_ns, unit="ns")

        value = 0
        for i in range(8):
            await Timer(self.bit_time_ns, unit="ns")
            bit = int(self.tx.value)
            value |= bit << i

        # stop bit
        await Timer(self.bit_time_ns, unit="ns")

        return value

    async def run(self):
        """Continuously receive and display UART output"""
        test_name = "UART-Terminal"
        logger = logging.getLogger(test_name)
        file_handler = logging.FileHandler(f"simulation_{test_name}.log", mode='w')
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
        logger.setLevel(logging.INFO)
        while True:
            ch = await self.receive_byte()
            c = chr(ch)

            if c == "\r":
                continue
            elif c == "\n":
                if self.echo:
                    logger.info(self.buffer)
                self.buffer = ""
            else:
                self.buffer += c
