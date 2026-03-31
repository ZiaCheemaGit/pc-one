# Build Output
BUILD_DIR_BIOS = build/BIOS
BUILD_ROOT = build

# Toolchain
CC      = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy

# Architecture flags
CFLAGS  = -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -O2 -Wall
CFLAGS += -Iinclude

# BIOS Sources
BIOS_LINKER = BIOS/link.ld
BIOS_SRC  = BIOS/bios.c BIOS/crt0.S

# Other Sources
DRIVER_SRC = $(wildcard drivers/*.c)
LIB_SRC = $(wildcard lib/*.c)
TESTS_SRC = $(wildcard tests/*.c)

# Output files
ELF  = $(BUILD_DIR_BIOS)/bios.elf
DUMP = $(BUILD_DIR_BIOS)/bios.dump
BIN  = $(BUILD_DIR_BIOS)/bios.bin
HEX  = $(BUILD_DIR_BIOS)/bios.hex

all: clean hex_bios

build_bios:
	mkdir -p $(BUILD_DIR_BIOS)

elf_bios: build_bios
	$(CC) $(CFLAGS) -T \
	$(BIOS_LINKER) $(BIOS_SRC) \
	$(LIB_SRC) $(DRIVER_SRC) \
	-lgcc -o $(ELF)

dump_bios: elf_bios
	$(OBJDUMP) -d -M numeric,no-aliases $(ELF) > $(DUMP)

bin_bios: dump_bios
	$(OBJCOPY) -O binary $(ELF) $(BIN)

hex_bios: bin_bios
	python3 ../python_helper/bin2hex32.py $(BIN) > $(HEX)

clean:
	rm -rf $(BUILD_ROOT)


