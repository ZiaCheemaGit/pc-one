# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int main(void)
{
    uart_println("Hello from pc-one!");

    delay_second(5);

    uart_println("Display plain White color on VGA Screen");
    display_plain_color(CYAN_COLOR);
    uart_println("Done");

    while (1){};
}

