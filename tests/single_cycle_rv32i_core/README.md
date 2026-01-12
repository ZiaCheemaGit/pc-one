# Single Cycle RV32I 
The cpu i.e an RV32I core is tested using [cocotb](https://www.cocotb.org/). Assembly and c/cpp
programs are used for Exhaustive testing of the core.These c/cpp and assembly programs are ran 
on the core by first converting them to hex file(One hex file per program). This hex file is read into
a ram. That ram is connected to the cpu and thus a von-neuman architecture approach is used to
test the cpu.

## Instr format
This directory contains python classes which help in debugging, logging and 
converting instructions from `binary-->assembly` and vice-versa. In future it might could
be used for building a custom assembler too.

## Test Cases
This directory contains assembly and c/cpp programs which the cpu runs successfully.It contains a
`Makefile` which generates a `hex`, an `elf` and a `dump` file from each asm and c/cpp file. `linker files` sub
directory contains file which are used by gcc to compile test files to hex. 

# Von-Neuman
There is a `ram_16KB` and `TOP` module. For testing a cpu we must run a program on it i.e a hex file. 
This can be done by connecting the cpu to a memory. In real world a unified memory is used. Hence
a Von-Neuman architecture environment approach is used.
