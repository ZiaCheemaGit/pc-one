# Tests
---
This directory contains cocotb tests for all the hardware. Primary purpose of 
tests is to test hardware but these tests also are used by CI.

Each sub directory contains a hex dir in which there is a hex file.This hex file is 
obtained bt compiling c/cppor assembly code using riscv-unknown-elf. For more clarity on how 
to compile using riscv-unknown-elf, see the Makefile in each sub directory.
 