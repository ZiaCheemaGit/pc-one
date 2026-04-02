# include "../include/tests.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int test_1(void)
{
    uart_println("Hello from pc-one!");
    
    uart_println("Display plain Red on VGA Screen after 7 seconds");
    delay_second(7);
    display_plain_color(RED_COLOR);
    uart_println("Red color Done");

    uart_println("Display plain CYAN on VGA Screen after 7 seconds");
    delay_second(7);
    display_plain_color(CYAN_COLOR);
    uart_println("CYAN color Done");

    for (int i = 0; i < 50; i++){
        uart_println("Wait 3 second"); 
        delay_second(3);
        
        char c = uart_getc();
        
        uart_print("Received: ");
        uart_putc(c);
        uart_println("");
    }
    return 0;
}


