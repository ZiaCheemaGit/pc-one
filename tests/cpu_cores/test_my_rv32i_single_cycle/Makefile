# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/core.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/adder32.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/alu_control.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/control_unit.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/main_alu.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/mux_2X1.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/mux_4X1.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/mux_5X1.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/pc.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/pc_src_control.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/register_file.v
VERILOG_SOURCES += $(PWD)/../../../cpu_cores/single_cycle_rv32i_core/sign_ext_12_to_32.v

# use VHDL_SOURCES for VHDL files

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = core

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

