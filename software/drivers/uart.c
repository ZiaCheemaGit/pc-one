#include "../include/uart.h"

void uart_putc(char c){
    volatile uint32_t *uart_data   = (volatile uint32_t *)UART_DATA_ADDR;
    volatile uint32_t *uart_tx_status = (volatile uint32_t *)UART_TX_STATUS_ADDR;

    while (*uart_tx_status) {
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

char uart_getc(){
    volatile uint32_t *uart_data   = (volatile uint32_t *)UART_DATA_ADDR;
    char r = (char)(*uart_data);
    return r;
}

void int_to_string(int num, char *str) {
    int i = 0, temp = num;

    if (num == 0) {
        str[i] = '0';
        i++;
        str[i] = '\0';
        return;
    }

    while (temp > 0) {
        str[i++] = (temp % 10) + '0';
        temp /= 10;
    }

    str[i] = '\0';

    // reverse string
    for (int j = 0; j < i/2; j++) {
        char t = str[j];
        str[j] = str[i-j-1];
        str[i-j-1] = t;
    }
}

