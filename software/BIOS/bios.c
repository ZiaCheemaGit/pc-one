# include "../include/uart.h"
# include "../include/vga.h"
# include "../include/time.h"

static bool POST_EN = true;

static int power_on_self_test() {
    // test_cpu

    // test UART (Both Directions)
    
    // test VGA

    // test RAM

    // test memory map

    // test timer
    return 0;
}

int bios(void) {
    if(POST_EN) {
        if(power_on_self_test()) {

        }
    }
    
    
    return 0;
}

