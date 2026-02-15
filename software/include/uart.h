#ifndef UART_H
#define UART_H

#include <stdint.h>

/* Memory-mapped UART addresses */
#define UART_DATA_ADDR    0x00004000
#define UART_STATUS_ADDR  0x00004004

/* Low-level character transmit */
void uart_putc(char c);

/* Print string (no newline) */
void uart_print(const char *s);

/* Print string with CRLF */
void uart_println(const char *s);

#endif /* UART_H */
