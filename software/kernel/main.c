# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

// int main(void)
// {
//     uart_println("Hello from pc-one!");
    
//     uart_println("Display plain Red on VGA Screen after 7 seconds");
//     delay_second(7);
//     display_plain_color(RED_COLOR);
//     uart_println("Red color Done");

//     uart_println("Display plain CYAN on VGA Screen after 7 seconds");
//     delay_second(7);
//     display_plain_color(CYAN_COLOR);
//     uart_println("CYAN color Done");

//     while (1){
//         uart_println("Wait 3 second"); 
//         delay_second(3);
        
//         char c = uart_getc();
        
//         uart_print("Received: ");
//         uart_putc(c);
//         uart_println("");
//     };
// }


// int main(void)
// {
//     char c = uart_getc();
//     uart_print("Received: ");
//     uart_putc(c);
//     uart_println("");
//     uart_println("Wait 3 second"); 
//     delay_second(3);
    
//     c = uart_getc();
//     uart_print("Received: ");
//     uart_putc(c);
//     uart_println("");
//     uart_println("Wait 3 second"); 
//     delay_second(3);

//     c = uart_getc();
//     uart_print("Received: ");
//     uart_putc(c);
//     uart_println("");
//     uart_println("Wait 3 second"); 
//     delay_second(3);

//     while(1){}
// }


int main(void)
{
    char c = uart_getc();
    uart_putc(c);
    uart_println("");
    
    c = uart_getc();
    uart_putc(c);
    uart_println("");

    c = uart_getc();
    uart_putc(c);
    uart_println("");

    while(1){}
}


// int main(void)
// {
//     int a = 37;
//     int b = 7;
//     int c = a - b + 35;

//     uart_putc(c);
//     uart_println("");

//     while(1){}
// }

