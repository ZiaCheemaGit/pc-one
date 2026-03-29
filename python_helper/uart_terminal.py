import logging

from cocotb.triggers import Timer

class UARTTerminal:
    """
    UART terminal emulator (8N1)
    """

    def __init__(self, threshold_cycles, LOGGING_ON, logger: logging, dut, tx, baud_clks, clk_period_ns=10):
        self.LOGGING_ON = LOGGING_ON
        self.logger = logger
        self.dut = dut
        self.tx = tx

        self.stopTerminal = False
        self.threshold = threshold_cycles

        self.bit_time_ns = baud_clks * clk_period_ns
        self.half_bit_ns = self.bit_time_ns // 2

        self.buffer = ""

    async def receive_byte(self):
        """Receive one UART byte using real-time sampling"""

        count = 0
        # wait for start bit
        while int(self.tx.value) == 1: 
            await Timer(1, unit="ns")
            count += 1
            if count >= self.threshold:
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

        printed_chars = 0
        
        while True:# not self.stopTerminal:
            ch = await self.receive_byte()

            if ch is not None:
                c = chr(ch)
                if c == "\n":
                    print_line = self.buffer[printed_chars:]
                    self.logger.critical(f"[UART Terminal] - {print_line}")
                    self.buffer += c
                    printed_chars = len(self.buffer)
                else:
                    self.buffer += c

        self.logger.info(f"[UART Terminal] - UART stopped")    

        return self.buffer

class UARTDriver:
    """
    Drives UART RX line toward DUT (8N1 format)
    """

    def __init__(self, rx_signal, baud_clks, clk_period_ns):
        self.rx = rx_signal
        self.bit_time_ns = baud_clks * clk_period_ns

    async def _send_byte(self, value: int):
        """Send one byte over UART"""

        # start bit
        self.rx.value = 0
        await Timer(self.bit_time_ns, unit="ns")

        # data bits (LSB first)
        for i in range(8):
            self.rx.value = (value >> i) & 1
            await Timer(self.bit_time_ns, unit="ns")

        # stop bit
        self.rx.value = 1
        await Timer(self.bit_time_ns, unit="ns")

    async def send_char(self, char: str):
        await self._send_byte(ord(char))

    async def send_string(self, string: str):
        for ch in string:
            await self.send_char(ch)




