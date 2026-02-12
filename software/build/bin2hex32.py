import sys
data = open(sys.argv[1], "rb").read()

for i in range(0, len(data), 4):
    word = data[i:i+4]
    if len(word) < 4:
        word = word.ljust(4, b'\x00')
    val = int.from_bytes(word, byteorder="little")
    print(f"{val:08x}")
