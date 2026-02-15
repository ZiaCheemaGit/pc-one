import pygame
import sys

H_VISIBLE = 640
H_FRONT   = 16
H_SYNC    = 96
H_BACK    = 48
H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK

V_VISIBLE = 480
V_FRONT   = 10
V_SYNC    = 2
V_BACK    = 33
V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK

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
