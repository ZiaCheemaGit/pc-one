# include "../include/time.h"
# include "../include/uart.h"

void delay_second(int seconds)
{
    uart_println("CPU on hold for 5 seconds");
    volatile int cycles;
    while (seconds--)
    {
        cycles = CPU_FREQ;
        while (cycles--){}
    }
}




