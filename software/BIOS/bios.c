# include "../include/tests.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int bios(void)
{
    uart_println("Hello from PC-ONE!");
    return 0;
}


