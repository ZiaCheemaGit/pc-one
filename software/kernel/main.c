# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int main(void)
{
    uart_println("Hey!");
    
    while (1){
        uart_print("R: ");
        uart_putc(uart_readc());
        uart_println("");
    };
}

