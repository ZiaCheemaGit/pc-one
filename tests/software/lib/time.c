# include "../include/time.h"

void delay_one_second()
{
    register int cycles = CPU_FREQ / 3;

    while(cycles--)
    {
        __asm__("nop");
    }
}

void delay_second(int seconds){
    while(seconds--){
        delay_one_second();
    }
}




