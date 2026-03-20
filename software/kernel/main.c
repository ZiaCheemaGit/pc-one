#include "../include/uart.h"

int main(void)
{
    uart_putc('H');
    uart_putc('e');
    uart_putc('y');
    uart_putc('!');
    uart_putc('\r');
    uart_putc('\n');

    while (1){
        
    };

}
