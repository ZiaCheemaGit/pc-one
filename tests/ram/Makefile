SIM ?= icarus

TOPLEVEL_LANG = verilog

VERILOG_SOURCES += $(PWD)/../../hardware/memory/rom.v

COCOTB_TOPLEVEL = rom

COCOTB_TEST_MODULES = test

include $(shell cocotb-config --makefiles)/Makefile.sim

ifndef PROGRAM_FILE
$(error PROGRAM_FILE is not set. Use: make PROGRAM_FILE=path_to_hex_file)
endif

export PROGRAM_FILE
COCOTB_PLUSARGS += +PROGRAM_FILE=$(PROGRAM_FILE)

