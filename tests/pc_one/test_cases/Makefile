# Toolchain
CC      := riscv64-unknown-elf-gcc
OBJDUMP := riscv64-unknown-elf-objdump
OBJCOPY := riscv64-unknown-elf-objcopy

# Directories
ASM_DIR := asm_tests
CPP_DIR := c-cpp_tests
OUT_DIR := generated_hex

# Find sources
ASM_SRCS := $(wildcard $(ASM_DIR)/*.s)
C_SRCS   := $(wildcard $(CPP_DIR)/*.c)
CPP_SRCS := $(wildcard $(CPP_DIR)/*.cpp)

SRCS := $(ASM_SRCS) $(C_SRCS) $(CPP_SRCS)

# Flags
ARCH_FLAGS    := -march=rv32i -mabi=ilp32
COMMON_FLAGS  := -ffreestanding -nostdlib
LINKER_SCRIPT := linker_files/link.ld
CRT0          := linker_files/crt0.S

# Map:
# asm_tests/test_basic.s  -> generated_hex/asm_tests_test_basic/test_basic.hex
# c-cpp_tests/test_math.c -> generated_hex/c-cpp_tests_test_math/test_math.hex

define OUTDIR
$(OUT_DIR)/$(subst /,_,$(basename $(1)))
endef

define HEXFILE
$(call OUTDIR,$(1))/$(notdir $(basename $(1))).hex
endef

HEX_FILES := $(foreach src,$(SRCS),$(call HEXFILE,$(src)))

.PHONY: all clean

all: clean $(HEX_FILES)


# Build rule
$(OUT_DIR)/%/%.hex:
	@echo "ERROR: pattern rule mismatch"
	@exit 1

# Real build rule using eval
define BUILD_RULE
$(call HEXFILE,$(1)):
	@echo "Building $(1)"
	@mkdir -p $(call OUTDIR,$(1))
	$(CC) $(ARCH_FLAGS) $(COMMON_FLAGS) \
		-T $(LINKER_SCRIPT) \
		$(CRT0) $(1) -lgcc -o $(call OUTDIR,$(1))/$(notdir $(basename $(1))).elf
	$(OBJDUMP) -d -M numeric,no-aliases \
		$(call OUTDIR,$(1))/$(notdir $(basename $(1))).elf \
		> $(call OUTDIR,$(1))/$(notdir $(basename $(1))).dump
	$(OBJCOPY) -O binary \
		$(call OUTDIR,$(1))/$(notdir $(basename $(1))).elf \
		$(call OUTDIR,$(1))/$(notdir $(basename $(1))).bin
	python3 bin2hex32.py \
		$(call OUTDIR,$(1))/$(notdir $(basename $(1))).bin > $$@
endef

$(foreach src,$(SRCS),$(eval $(call BUILD_RULE,$(src))))

clean:
	rm -rf $(OUT_DIR)
