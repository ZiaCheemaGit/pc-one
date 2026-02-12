
all: clean hex

elf:
	riscv64-unknown-elf-gcc -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -T linker_files/link.ld linker_files/crt0.S rom_image.c -lgcc -o rom_image.elf

dump: elf
	riscv64-unknown-elf-objdump -d -M numeric,no-aliases rom_image.elf > rom_image.dump

bin: dump
	riscv64-unknown-elf-objcopy -O binary rom_image.elf rom_image.bin

hex: bin
	python3 bin2hex32.py rom_image.bin > rom_image.hex

clean:
	rm -rf *.elf *.dump *.bin *.hex
