# ifndef UART_H
# define UART_H

# include <stdint.h>

#define UART_DATA_ADDR    0x00004000
#define UART_STATUS_ADDR  0x00004004

void uart_putc(char c);

void uart_print(const char *s);

void uart_println(const char *s);

# endif 
