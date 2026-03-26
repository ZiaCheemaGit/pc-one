# ifndef VGA_H
# define VGA_H

# include <stdint.h>

#define VRAM_START_ADDR 0x00004008
#define VRAM_END_ADDR 0x00007C2F

#define BLACK_COLOR 0
#define CYAN_COLOR 1
#define RED_COLOR 2
#define WHITE_COLOR 3

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 480

void display_plain_color(int color);

# endif 




