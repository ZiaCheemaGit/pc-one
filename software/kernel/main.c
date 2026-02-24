#include "../include/uart.h"

int main(void)
{
    uart_putc('H');
    uart_putc('e');
    uart_putc('y');
    uart_putc('!');
    uart_putc('\r');
    uart_putc('\n');

    while (1);
}

// this would work once sb, lbu lb, etc all remaining instructions
// with byte load and store are implemented
// uart_println("Hey!");