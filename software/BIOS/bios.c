# include "../include/bios.h"
# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

// void int_to_string(int num, char *str) {
//     int i = 0, temp = num;

//     if (num == 0) {
//         str[i] = '0';
//         i++;
//         str[i] = '\0';
//         return;
//     }

//     while (temp > 0) {
//         str[i++] = (temp % 10) + '0';
//         temp /= 10;
//     }

//     str[i] = '\0';

//     // reverse string
//     for (int j = 0; j < i/2; j++) {
//         char t = str[j];
//         str[j] = str[i-j-1];
//         str[i-j-1] = t;
//     }
// }

// void loadBootLoader(){

// }

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


