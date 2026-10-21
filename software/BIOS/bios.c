# include "../include/tests.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int bios(void)
{
    uart_println("Hello from PC-ONE!");
    delay_second(5);

    display_plain_color(RED_COLOR);
    uart_println("Displaying red color for next 15 seconds");
    delay_second(15);

    display_plain_color(WHITE_COLOR);
    uart_println("Displaying white color for next 15 seconds");
    delay_second(15);
    
    uart_println("\n");
    uart_println("This is the UART Output for PC-ONE");
    return 0;
}


