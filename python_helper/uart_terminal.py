import logging

from cocotb.triggers import Timer

class UARTTerminal:
    """
    UART terminal emulator (8N1) with ZERO drift.
    Matches FPGA + minicom exactly.
    """

    def __init__(self, expected_string, LOGGING_ON, logger: logging, dut, tx, baud_clks, clk_period_ns=10):
        self.expected_string = expected_string
        self.LOGGING_ON = LOGGING_ON
        self.logger = logger
        self.dut = dut
        self.tx = tx

        self.stopTerminal = False

        self.bit_time_ns = baud_clks * clk_period_ns
        self.half_bit_ns = self.bit_time_ns // 2

        self.buffer = ""

    async def receive_byte(self):
        """Receive one UART byte using real-time sampling"""

        threshold = 100_000
        count = 0

        # wait for start bit
        while int(self.tx.value) == 1: 
                await Timer(1, unit="ns")
                count += 1
                if count >= threshold:
                    self.logger.info("tx pin idle for Threshold cycles")
                    self.stopTerminal = True
                    return

        # move to middle of start bit
        await Timer(self.half_bit_ns, unit="ns")

        value = 0
        for i in range(8):
            await Timer(self.bit_time_ns, unit="ns")
            bit = int(self.tx.value)
            value |= bit << i

        # stop bit
        await Timer(self.bit_time_ns, unit="ns")

        if self.LOGGING_ON and chr(value):
            self.logger.info(f"[LOGGING_ON] - Received Byte = {value}")

        return value

    async def run(self):
        """Continuously receive and display UART output"""

        while not self.stopTerminal:
            ch = await self.receive_byte()

            if ch is not None:
                c = chr(ch)
                if c == "\n":
                    self.logger.critical(f"[UART Terminal] - {self.buffer}")
                    self.buffer += c
                else:
                    self.buffer += c

        self.logger.info(f"[UART Terminal] - UART stopped")    

        if self.expected_string != self.buffer:
            raise Exception(f"Expected = {self.expected_string}, Received = {self.buffer}")
        else:
            self.logger.info(f"Expected = {self.expected_string}, Received = {self.buffer} UART Test Passed")
