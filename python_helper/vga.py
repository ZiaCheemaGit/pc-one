import pygame
import sys


class VGAFormat:
    def __init__(
            self, frequency : int, 
            H_VISIBLE : int, H_FRONT : int, H_SYNC : int, H_BACK : int,
            V_VISIBLE : int, V_FRONT : int, V_SYNC : int, V_BACK : int,
        ):
        self.height = V_VISIBLE
        self.width = H_VISIBLE
        self.frequency = frequency

        self.H_VISIBLE = H_VISIBLE
        self.H_FRONT   = H_FRONT
        self.H_SYNC    = H_SYNC
        self.H_BACK    = H_BACK
        self.H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK
        
        self.V_VISIBLE = V_VISIBLE
        self.V_FRONT   = V_FRONT
        self.V_SYNC    = V_SYNC
        self.V_BACK    = V_BACK
        self.V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK
         

"""
VESA Table source

https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml

More entries can be added as per requirements
"""

VGA_640_480_60Hz = VGAFormat(60, 640, 16, 96, 48, 480, 11, 2, 31)

VESA_TABLE = [
    VGA_640_480_60Hz
]

class VGAMonitor:

    def __init__(self):
        pygame.init()
        self.screen = pygame.display.set_mode((H_VISIBLE, V_VISIBLE))
        pygame.display.set_caption("VGA Monitor Simulator")
        self.surface = pygame.Surface((H_VISIBLE, V_VISIBLE))

        self.prev_clk = 0
        self.prev_hsync = 1
        self.prev_vsync = 1

        self.x = 0
        self.y = 0

        self.h_count = 0
        self.v_count = 0

    def step(self, clk, hsync, vsync, r, g, b):
        if self.prev_clk == 0 and clk == 1:

            if self.prev_vsync == 1 and vsync == 0:
                self.v_count = 0
                self.y = 0
                self.update_display()

            if self.prev_hsync == 1 and hsync == 0:
                self.h_count = 0
                self.x = 0
                self.v_count += 1
                self.y = self.v_count

            if (self.h_count < H_VISIBLE) and (self.v_count < V_VISIBLE):
                color = (
                    int(r * 17),
                    int(g * 17),
                    int(b * 17)
                )
                if self.x < H_VISIBLE and self.y < V_VISIBLE:
                    self.surface.set_at((self.x, self.y), color)

                self.x += 1

            self.h_count += 1

        self.prev_clk = clk
        self.prev_hsync = hsync
        self.prev_vsync = vsync

    def update_display(self):
        self.screen.blit(self.surface, (0, 0))
        pygame.display.flip()

    def handle_events(self):
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()


def main():
    monitor = VGAMonitor()
    clock = pygame.time.Clock()

    while True:
        monitor.handle_events()
        clock.tick(1000)


if __name__ == "__main__":
    main()
