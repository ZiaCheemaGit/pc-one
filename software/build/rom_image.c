#define UART_DATA_ADDR    0x00004000
#define UART_STATUS_ADDR  0x00004004

static inline void uart_putc(char c)
{
    volatile unsigned int *uart_data = (volatile unsigned int *)UART_DATA_ADDR;
    volatile unsigned int *uart_status = (volatile unsigned int *)UART_STATUS_ADDR;

    while ((*uart_status & 0x1) != 0) {
        __asm__ volatile ("" ::: "memory");
    }

    *uart_data = (unsigned int)c;
}

void uart_print(const char *s)
{
    while (*s) {
        uart_putc(*s++);
    }
}

void uart_println(const char *s)
{
    uart_print(s);
    uart_putc('\r');
    uart_putc('\n');
}

int main(void)
{
    uart_putc('H');
    uart_putc('e');
    uart_putc('y');
    uart_putc('!');
    uart_putc('\r');
    uart_putc('\n');

    // this would work once sb, lbu lb, etc all remaining instructions
    // with byte load and store are implemented
    // uart_println("Hey!");
}

