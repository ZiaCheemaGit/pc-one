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
    uart_println("Hello from PC-ONE CPU!");

    return 0;
}

