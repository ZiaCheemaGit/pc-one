# Makefile
PWD := $(shell pwd)
# simulator
SIM ?= icarus

# hdl 
TOPLEVEL_LANG ?= verilog

# single_cycle_rv32i_core files
VERILOG_SOURCES += $(PWD)/../../../../hardware/processors/five_stage_pipelined_rv32i_core/five_stage_pipelined_rv32i_core.v

VERILOG_SOURCES += $(PWD)/../../../../hardware/processors/single_cycle_rv32i_core/single_cycle_rv32i_core.v

# processor lib files
VERILOG_SOURCES += $(PWD)/../../../../hardware/processors/lib/*.v

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = five_stage_pipelined_rv32i_core

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test_core

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim


