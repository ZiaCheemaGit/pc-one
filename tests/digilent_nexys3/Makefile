# Makefile

# simulator
SIM ?= icarus

# hdl 
TOPLEVEL_LANG ?= verilog

# single_cycle_rv32i_core files
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/core.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/adder32.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/alu_control.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/control_unit.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/main_alu.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/mux_4X1.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/mux_5X1.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/pc.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/pc_src_control.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/register_file.v
VERILOG_SOURCES += $(PWD)/../../hardware/single_cycle_rv32i_core/sign_ext_12_to_32.v

# pc_one
VERILOG_SOURCES += $(PWD)/../../hardware/pc_one/pc_one.v

# FPGA top
VERILOG_SOURCES += $(PWD)/../../FPGA_tests/test_uart/digilent_nexys3_spartan6/windows_ise_project/top_nexys3.v

# memories
VERILOG_SOURCES += $(PWD)/../../hardware/memory/rom.v
VERILOG_SOURCES += $(PWD)/../../hardware/memory/ram.v

# MMU
VERILOG_SOURCES += $(PWD)/../../hardware/MMU/MMU.v

#UART
VERILOG_SOURCES += $(PWD)/../../hardware/UART/uart_tx.v
 
# Program file (passed from terminal)
PROGRAM_FILE ?=

ifndef PROGRAM_FILE
$(error PROGRAM_FILE is not set. Use: make PROGRAM_FILE=path_to_hex_file)
endif

export PROGRAM_FILE
COCOTB_PLUSARGS += +PROGRAM_FILE=$(PROGRAM_FILE)

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = pc_one

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim


