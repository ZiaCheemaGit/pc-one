# include "../../../../software/include/uart.h"
# include "../../../../software/include/vga.h"
# include "../../../../software/include/time.h"

static void fill_rect(
    volatile uint8_t *fb,
    int x, int y,
    int width, int height,
    int color
) {
    if (x < 0) {
        width += x;
        x = 0;
    }

    if (y < 0) {
        height += y;
        y = 0;
    }

    if (x >= SCREEN_WIDTH || y >= SCREEN_HEIGHT)
        return;

    if (x + width > SCREEN_WIDTH)
        width = SCREEN_WIDTH - x;

    if (y + height > SCREEN_HEIGHT)
        height = SCREEN_HEIGHT - y;

    if (width <= 0 || height <= 0)
        return;

    for (int row = y; row < y + height; row++) {
        for (int col = x; col < x + width; col++) {
            fb[row * SCREEN_WIDTH + col] =
                (uint8_t)(color & 0x03);
        }
    }
}

static void draw_rect(
    volatile uint8_t *fb,
    int x, int y,
    int width, int height,
    int color
) {
    fill_rect(fb, x, y, width, 1, color);
    fill_rect(fb, x, y + height - 1, width, 1, color);
    fill_rect(fb, x, y, 1, height, color);
    fill_rect(fb, x + width - 1, y, 1, height, color);
}

void display_vga_test_pattern(void) {
    volatile uint8_t *fb =
        (volatile uint8_t *)VRAM_START_ADDR;

    fill_rect(fb, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT,
              BLACK_COLOR);

    draw_rect(fb, 2, 2,
              SCREEN_WIDTH - 4, SCREEN_HEIGHT - 4,
              WHITE_COLOR);

    const int colors[] = {
        CYAN_COLOR,
        RED_COLOR,
        WHITE_COLOR,
        BLACK_COLOR
    };

    for (int i = 0; i < 4; i++) {
        fill_rect(fb, 16 + i * 72, 24, 72, 48,
                  colors[i]);
    }

    draw_rect(fb, 15, 23, 290, 50, WHITE_COLOR);

    for (int row = 0; row < 16; row++) {
        for (int col = 0; col < 16; col++) {
            int color = ((row + col) & 1)
                        ? WHITE_COLOR
                        : BLACK_COLOR;

            fill_rect(fb,
                      64 + col * 12,
                      120 + row * 12,
                      12, 12,
                      color);
        }
    }

    draw_rect(fb, 62, 118, 196, 196, CYAN_COLOR);

    fill_rect(fb, 159, 120, 1, 192, RED_COLOR);
    fill_rect(fb, 64, 215, 192, 1, RED_COLOR);

    for (int x = 0; x < 288; x++) {
        int color = (x & 1) ? BLACK_COLOR : WHITE_COLOR;
        fill_rect(fb, 16 + x, 350, 1, 24, color);
    }

    draw_rect(fb, 15, 349, 290, 26, CYAN_COLOR);
}

int bios(void) {
    display_vga_test_pattern();
    uart_println("VGA test pattern written to VRAM.");
    uart_println("Waiting 1 second...");
    delay_second(1);
    return 0;
}
