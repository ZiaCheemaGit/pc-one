# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int main(void)
{
    uart_println("H!");

    uart_println("Sx");
    
    while (1){
        char c = uart_readc();
        uart_print("Received: ");
        uart_putc(c);
        uart_putc('\n');
        uart_println("Delay 3 second");
        delay_second(3);
    };
}

