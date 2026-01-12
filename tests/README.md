# Tests
This directory contains tests for all the hardware and software. Primary purpose is 
testing but these tests are also used by CI. There is one sub directory 
per hardware/software module.

## Single_cycle_rv32i_core
The cpu i.e an RV32I core is tested using [cocotb](https://www.cocotb.org/). Assembly and c/cpp
programs are used for Exhaustive testing of the core.These c/cpp and assembly programs are ran 
on the core by first converting them to hex file(One hex file per program). This hex file is read into
a ram. That ram is connected to the cpu and thus a von-neuman architecture approach is used to
test the cpu.

 
