

#define UART_BASE 0x4000
#define UART_STATUS 0x4004

static inline void uart_putc(char c) 
{
    *(volatile unsigned int*)UART_BASE = c;
}

void uart_print(const char *s) 
{
    while (*s) uart_putc(*s++);
}

int main()
{
    uart_print("Hello from RV32I!\n");
}


// static inline void uart_putc(char c)
// {
//     while (*(volatile unsigned int*)UART_STATUS & UART_BUSY);
//     *(volatile unsigned int*)UART_BASE = c;
// }

