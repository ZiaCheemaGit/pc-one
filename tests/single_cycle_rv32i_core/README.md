## Single_cycle_rv32i_core
The cpu i.e an RV32I core is tested using [cocotb](https://www.cocotb.org/). Assembly and c/cpp
programs are used for Exhaustive testing of the core.These c/cpp and assembly programs are ran 
on the core by first converting them to hex file(One hex file per program). This hex file is read into
a ram. That ram is connected to the cpu and thus a von-neuman architecture approach is used to
test the cpu.

There is a `ram_16KB` and `TOP` module which makes this possible. 

This hex file is 
obtained by compiling c/cpp or assembly code using riscv-unknown-elf. For more clarity on how 
to compile using riscv-unknown-elf, see the Makefile in each sub directory.