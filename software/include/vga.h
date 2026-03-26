# ifndef VGA_H
# define VGA_H

# include <stdint.h>

#define VRAM_START_ADDR 0x00004008
#define VRAM_END_ADDR 0x00007C2F

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480

#define VRAM ((volatile uint32_t*)VRAM_START_ADDR)

void display_white(void);
void display_black(void);

void draw_pixel(uint32_t x, uint32_t y, uint8_t color);

# endif 




