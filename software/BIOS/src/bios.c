#include "../include/uart.h"
#include "../include/vga.h"
#include "../include/time.h"
#include "../include/post.h"


static bool POST_EN = true;
static bool BIOS_MENU_UART_EN = true;


int bios(void) {
    if (POST_EN) {
        if(power_on_self_test()) {
        }
    }
    
    if (BIOS_MENU_UART_EN) {
        bios_menu_on_uart();
    }
    
    return 0;
}
