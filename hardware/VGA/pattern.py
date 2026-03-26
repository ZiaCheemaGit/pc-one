WIDTH = 320
HEIGHT = 480

with open("vram_init.hex", "w") as f:
    print("Starting...")
    for y in range(HEIGHT):
        for x in range(WIDTH):
            horizontal_lines = (y // 20) % 4
            vertical_lines = (x // 20) % 4
            checkerboard = ((x // 16) ^ (y // 16)) & 3
            c0 = 0  # black 
            c1 = 1  # light blue
            c2 = 2  # red
            c3 = 3  # white
            f.write(f"{c3:x}\n")


