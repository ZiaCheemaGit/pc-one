# include "../include/vga.h"

void display_plain_color(int color)
{
    volatile uint8_t *vram_address = (volatile uint8_t *)VRAM_START_ADDR;

    for (int i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
    {
        vram_address[i] = (uint8_t)(color & 0x03);
    }
}


