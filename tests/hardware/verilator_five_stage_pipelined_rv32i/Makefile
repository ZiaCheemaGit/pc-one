all: verilate compile_sim run_sim

HARDWARE_DESIGNS_DIR = ../../../hardware

HEX ?= test_case/build/sim.hex

TEST_BENCH = main.cpp

TOP_MODULE = top_fpga

FPGA = $(HARDWARE_DESIGNS_DIR)/FPGA/top_fpga.v
BOOT_ROM = $(HARDWARE_DESIGNS_DIR)/memories/boot_rom_synchronus.v
RAM = $(HARDWARE_DESIGNS_DIR)/memories/ram_synchronus.v
MMU = $(HARDWARE_DESIGNS_DIR)/MMU/MMU.v
PC_ONE = $(HARDWARE_DESIGNS_DIR)/pc_one/pc_one.v
FIVE_STAGE_PIPELINED_RV32I_CORE = $(HARDWARE_DESIGNS_DIR)/processors/five_stage_pipelined_rv32i_core/five_stage_pipelined_rv32i_core.v
CORE_LIB = $(HARDWARE_DESIGNS_DIR)/processors/lib/*.v
UART = $(HARDWARE_DESIGNS_DIR)/UART/*.v
VGA = $(HARDWARE_DESIGNS_DIR)/VGA/*.v

verilate:
	verilator --cc --exe --build -j 0 -Wall -Wno-fatal --top-module $(TOP_MODULE) \
	$(TEST_BENCH) \
	$(FPGA) $(BOOT_ROM) $(RAM) $(MMU) $(PC_ONE) $(FIVE_STAGE_PIPELINED_RV32I_CORE) \
	$(CORE_LIB) $(UART) $(VGA)

run_sim:
	./obj_dir/Vtop_fpga +PROGRAM_FILE=$(HEX)

