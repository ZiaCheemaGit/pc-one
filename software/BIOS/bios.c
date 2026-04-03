# include "../include/bios.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

void loadBootLoader(){

}

int bios(){
    uart_println("Hey!");

    int max = 100;
    int min = 36;
    int threshold = max - min;
    uart_print("Threshold: ");
    char s[10];
    int_to_string(threshold, s);
    uart_println(s);

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


