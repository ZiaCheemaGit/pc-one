# include "../include/bios.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

int bios(){
    uart_println("Hello from PC-ONE!");
    delay_second(1);
    for (int i = 0; i < 4; i++){
        uart_println("Wait 3 second"); 
        delay_second(3);
        
        char c = uart_getc();
        
        uart_print("Received: ");
        uart_putc(c);
        uart_println("");
    }

    while(1){}

    return 0;
}


