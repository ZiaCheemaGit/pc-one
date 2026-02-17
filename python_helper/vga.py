import pygame
import sys


class VGA_CABLE:
    def __init__(
            self, Red : int, Green : int, Blue : int, 
            H_SYNC: bool, V_SYNC: bool, pixel_clk_MHz : float
        ):
        self.red = Red
        self.green = Green
        self.blue = Blue

        self.H_SYNC = H_SYNC
        self.V_SYNC = V_SYNC

        self.pixel_clk_MHz = pixel_clk_MHz


class VGA_Format:
    def __init__(
            self, frequency : int, pixel_clk : float,
            H_VISIBLE : int, H_FRONT : int, H_SYNC : int, H_BACK : int,
            V_VISIBLE : int, V_FRONT : int, V_SYNC : int, V_BACK : int,
        ):
        self.height = V_VISIBLE
        self.width = H_VISIBLE
        self.frequency = frequency
        self.pixel_clk = pixel_clk

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

More entries can be added here
"""
VGA_480p = VGA_Format(60, 25.175, 640, 16, 96, 48, 480, 11, 2, 31)

VESA_TABLE = [
    VGA_480p,
]


class VGAMonitor:
    def __init__(self):
        pygame.init()
        self.format : VGA_Format = None

        self.x_position = 0
        self.y_position = 0

        self.prev_hsync = True
        self.prev_vsync = True

    def initialize_display(self):
        self.screen = pygame.display.set_mode(
            (self.format.H_VISIBLE, self.format.V_VISIBLE)
        )
        pygame.display.set_caption("VGA Monitor Simulator")

    def handle_events(self):
        """
        Check if user closed pygame GUI
        """
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

    def select_format(self, pixel_clk_MHz : float) -> VGA_Format:
        """
        Iterate over VESA_TABLE adn select matching 
        VGA Format
        """
        for fmt in VESA_TABLE:
            if abs(fmt.pixel_clk - pixel_clk_MHz) < 0.6:
                return fmt
        return None

    def update_display(self, VGA_CABLE: VGA_CABLE):
        VESA_STANDARD = self.select_format(VGA_CABLE.pixel_clk_MHz)
        if VESA_STANDARD is None:
            print(f"Invalid Pixel Clock = {VGA_CABLE.pixel_clk_MHz}")
            pygame.quit()
            sys.exit()

        if self.format is None or self.format != VESA_STANDARD:
            self.format = VESA_STANDARD
            self.initialize_display()
            self.x_position = 0
            self.y_position = 0

        if self.prev_hsync and not VGA_CABLE.H_SYNC:
            self.x_position = 0
            self.y_position += 1

        if self.prev_vsync and not VGA_CABLE.V_SYNC:
            self.y_position = 0
            pygame.display.flip()

        if (self.x_position < self.format.H_VISIBLE and
            self.y_position < self.format.V_VISIBLE):

            self.screen.set_at(
                (self.x_position, self.y_position),
                (VGA_CABLE.red, VGA_CABLE.green, VGA_CABLE.blue)
            )

        self.x_position += 1

        self.prev_hsync = VGA_CABLE.H_SYNC
        self.prev_vsync = VGA_CABLE.V_SYNC



def main():
    monitor = VGAMonitor()

    h_clk = 0
    v_clk = 0
    h_sync = False
    v_sync = False

    while True:
        monitor.handle_events()

        if h_clk < (640 + 16):
            h_sync = True
        elif h_clk >= (640 + 16) and h_clk < (640 + 16 + 96):
            h_sync = False
        elif h_clk >= (640 + 16 + 96) and h_clk < (640 + 16 + 96 + 48):
            h_sync = True
        elif h_clk >= (640 + 16 + 96 + 48):
            h_clk = 0
            v_clk += 1

        if v_clk < (480 + 10):
            v_sync = True
        elif v_clk >= (480 + 10) and v_clk < (480 + 10 + 2):
            v_sync = False
        elif v_clk >= (480 + 10 + 2) and v_clk < (480 + 10 + 2 + 33):
            v_sync = True
        elif v_clk >= (480 + 10 + 2 + 33):
            v_clk = 0

        vga_cable = VGA_CABLE(
            255,      
            255,      
            255,      
            h_sync,    
            v_sync,    
            25    
        )

        monitor.update_display(vga_cable)
        h_clk += 1


if __name__ == "__main__":
    main()

