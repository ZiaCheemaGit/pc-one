WIDTH = 320
HEIGHT = 480

with open("vram_init.hex", "w") as f:
    for y in range(HEIGHT):
        for x in range(WIDTH):
            horizontal_lines = (y // 20) % 4
            vertical_lines = (x // 20) % 4
            checkerboard = ((x // 16) ^ (y // 16)) & 3
            f.write(f"{horizontal_lines:x}\n")


