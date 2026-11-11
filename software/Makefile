# Build Output
BUILD_ROOT = build
BUILD_DIR_BIOS = $(BUILD_ROOT)/BIOS

# Toolchain
CC      = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy

# Architecture flags
CFLAGS  = -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -O2 -Wall -Iinclude

# BIOS Sources
BIOS_SRCS = BIOS/link.ld BIOS/crt0.S BIOS/src/*.c BIOS/include/*.h

# BIOS Output files
ELF  = $(BUILD_DIR_BIOS)/bios.elf
DUMP = $(BUILD_DIR_BIOS)/bios.dump
BIN  = $(BUILD_DIR_BIOS)/bios.bin
HEX  = $(BUILD_DIR_BIOS)/bios.hex

all: clean hex_bios

build_bios:
	mkdir -p $(BUILD_DIR_BIOS)

elf_bios: build_bios
	$(CC) $(CFLAGS) -T \
	$(BIOS_SRCS) \
	-lgcc -o $(ELF)

dump_bios: elf_bios
	$(OBJDUMP) -d -M numeric,no-aliases $(ELF) > $(DUMP)

bin_bios: dump_bios
	$(OBJCOPY) -O binary $(ELF) $(BIN)

hex_bios: bin_bios
	python3 ../python_helper/bin2hex32.py $(BIN) > $(HEX)

clean:
	rm -rf $(BUILD_ROOT)


