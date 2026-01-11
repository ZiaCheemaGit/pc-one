# =========================
# Toolchain
# =========================
CC      := riscv64-unknown-elf-gcc
OBJDUMP := riscv64-unknown-elf-objdump
OBJCOPY := riscv64-unknown-elf-objcopy

# =========================
# User input
# =========================
SRC ?= my_code.c
BASE := $(basename $(SRC))

# =========================
# Flags
# =========================
ARCH_FLAGS   := -march=rv32i -mabi=ilp32
COMMON_FLAGS := -ffreestanding -nostdlib
LINKER_SCRIPT := link.ld

# =========================
# Outputs
# =========================
ELF  := $(BASE).elf
DUMP := $(BASE).dump
HEX  := $(BASE).hex

# =========================
# Default target
# =========================
all: $(HEX)

# =========================
# ELF generation (C / C++ / ASM)
# =========================
$(ELF): $(SRC)
	$(CC) $(ARCH_FLAGS) $(COMMON_FLAGS) \
	      -T $(LINKER_SCRIPT) \
	      crt0.S $(SRC) -lgcc -o $@

# =========================
# Dump generation
# =========================
$(DUMP): $(ELF)
	$(OBJDUMP) -d -M numeric,no-aliases $< > $@

# =========================
# Hex generation (Option 1: depends on dump)
# =========================
$(HEX): $(DUMP)
	$(OBJCOPY) -O verilog $(ELF) $@

# =========================
# Clean
# =========================
clean:
	rm -f *.elf *.dump *.hex
