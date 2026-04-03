# ifndef UART_H
# define UART_H

# include <stdint.h>

#define UART_DATA_ADDR    0x00004000
#define UART_TX_STATUS_ADDR  0x00004004 // 1 = busy, 0 = ready 
#define UART_RX_STATUS_ADDR  0x00004008 // 1 = busy, 0 = ready

void uart_putc(char c);
void uart_print(const char *s);
void uart_println(const char *s);
char uart_getc(void); 
void int_to_string(int n, char *s);

# endif 
