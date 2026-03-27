#include "../include/uart.h"

void uart_putc(char c){
    volatile uint32_t *uart_data   = (volatile uint32_t *)UART_DATA_ADDR;
    volatile uint32_t *uart_tx_status = (volatile uint32_t *)UART_TX_STATUS_ADDR;

    while ((*uart_tx_status & 0x1) != 0) {
        __asm__ volatile ("" ::: "memory");
    }

    *uart_data = (uint32_t)c;
}

void uart_print(const char *s){
    while (*s) {
        uart_putc(*s++);
    }
}

void uart_println(const char *s){
    uart_print(s);
    uart_putc('\r');
    uart_putc('\n');
}

char uart_readc(){
    volatile uint32_t *uart_data   = (volatile uint32_t *)UART_DATA_ADDR;
    volatile uint32_t *uart_rx_status = (volatile uint32_t *)UART_RX_STATUS_ADDR;

    while ((*uart_rx_status & 0x1) != 0) {
        __asm__ volatile ("" ::: "memory");
    }

    return (char)(*uart_data & 0xFF);
}


