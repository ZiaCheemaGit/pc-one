# Makefile

# simulator
SIM ?= icarus

# hdl 
TOPLEVEL_LANG ?= verilog

# vga controller
VERILOG_SOURCES += $(PWD)/../../hardware/VGA/vga_controller.v

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = vga_controller

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim


