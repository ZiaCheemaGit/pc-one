# include "../include/tests.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int bios(void)
{
    while(1) {
        uart_println("Hello from PC-ONE!");
        delay_second(2);
    }
}


