# include "../include/vga.h"

void draw_pixel(uint32_t x, uint32_t y, uint8_t color)
{
    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT)
        return;
    
    uint32_t addr = y * SCREEN_WIDTH + x;
    volatile uint32_t *pixel = (volatile uint32_t *)(VRAM_START_ADDR + addr * 4);
    *pixel = color & 0x3;
}

void display_white(void)
{
    for (uint32_t i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
    {
        volatile uint32_t *pixel = (volatile uint32_t *)(VRAM_START_ADDR + i * 4);
        *pixel = 3;
    }
}

void display_black(void)
{
    for (uint32_t i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++)
    {
        volatile uint32_t *pixel = (volatile uint32_t *)(VRAM_START_ADDR + i * 4);
        *pixel = 0;
    }
}


