## Single Cycle RV32I Core
CPU is the most basic part of any computer. For this project an RV32I is built based on 
the [ISA](https://msyksphinz-self.github.io/riscv-isadoc/#_rv32i_rv64i_instructions) provided by RISCV. This choice is a good balance between simplicity and functionality. It is minimal enough to be easy to understand and implement, while still
being powerful enough to execute meaningful programs.

Here is RTL for this design: 
![RTL Schematic](../images/RV32I.png)