import logging

from cocotb.triggers import Timer

class UARTTerminal:
    """
    UART terminal emulator (8N1) with ZERO drift.
    Matches FPGA + minicom exactly.
    """

    def __init__(self, LOGGING_ON, logger: logging, dut, tx, baud_clks, clk_period_ns=10, echo=True):
        self.LOGGING_ON = LOGGING_ON
        self.logger = logger
        self.dut = dut
        self.tx = tx
        self.echo = echo

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
                if c == "\r":
                    continue
                elif c == "\n":
                    if self.echo:
                        self.logger.critical(f"[UART Terminal] - {self.buffer}")
                    self.buffer = ""
                else:
                    self.buffer += c

        if self.LOGGING_ON:
            self.logger.info(f"[LOGGING_ON] - UART stopped")
