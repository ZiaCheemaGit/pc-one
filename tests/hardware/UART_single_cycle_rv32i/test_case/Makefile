# Build Output
BUILD_ROOT = build
BUILD_DIR = $(BUILD_ROOT)/

# Toolchain
CC      = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy

# Architecture flags
CFLAGS  = -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -O2 -Wall
CFLAGS += -Iinclude

LINKER = ../../../../software/BIOS/link.ld
SRC  = uart_test.c ../../../../software/BIOS/crt0.S

# Other Sources
DRIVER_SRC = $(wildcard ../../../../software/drivers/*.c)
LIB_SRC = $(wildcard ../../../../software/lib/*.c)

# Output files
ELF  = $(BUILD_DIR)/uart_test.elf
DUMP = $(BUILD_DIR)/uart_test.dump
BIN  = $(BUILD_DIR)/uart_test.bin
HEX  = $(BUILD_DIR)/uart_test.hex

all: clean hex

build:
	mkdir -p $(BUILD_DIR)

elf: build
	$(CC) $(CFLAGS) -T \
	$(LINKER) $(SRC) \
	$(LIB_SRC) $(DRIVER_SRC) \
	-lgcc -o $(ELF)

dump: elf
	$(OBJDUMP) -d -M numeric,no-aliases $(ELF) > $(DUMP)

bin: dump
	$(OBJCOPY) -O binary $(ELF) $(BIN)

hex: bin
	python3 ../../../../python_helper/bin2hex32.py $(BIN) > $(HEX)

clean:
	rm -rf $(BUILD_ROOT)


