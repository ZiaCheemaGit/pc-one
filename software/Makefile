# Build Output
BUILD_DIR = build

# Toolchain
CC      = riscv64-unknown-elf-gcc
OBJDUMP = riscv64-unknown-elf-objdump
OBJCOPY = riscv64-unknown-elf-objcopy

# Architecture flags
CFLAGS  = -march=rv32i -mabi=ilp32 -ffreestanding -nostdlib -O2 -Wall
CFLAGS += -Iinclude

# Sources
KERNEL_SRC  = kernel/main.c
DRIVER_SRC  = drivers/uart.c
CRT0        = bootloader/crt0.S
LINKER      = bootloader/link.ld

# Output files
ELF  = $(BUILD_DIR)/rom_image.elf
DUMP = $(BUILD_DIR)/rom_image.dump
BIN  = $(BUILD_DIR)/rom_image.bin
HEX  = $(BUILD_DIR)/rom_image.hex

all: clean build hex

build:
	mkdir $(BUILD_DIR)

elf: build
	$(CC) $(CFLAGS) -T $(LINKER) \
	$(CRT0) $(KERNEL_SRC) $(DRIVER_SRC) \
	-lgcc -o $(ELF)

dump: elf
	$(OBJDUMP) -d -M numeric,no-aliases $(ELF) > $(DUMP)

bin: dump
	$(OBJCOPY) -O binary $(ELF) $(BIN)

hex: bin
	python3 ../python_helper/bin2hex32.py $(BIN) > $(HEX)

clean:
	rm -rf $(BUILD_DIR)
