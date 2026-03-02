# FPGA Tests
This directory contains all the tests which successfully run on an FPGA. After 
testing hdl designs in simulation we must test it on real hardware. For Example 
after successfully running assemlby and c/cpp programs on rv32i in simulation, we 
must also test that on an FPGA. 


You can also [Download Adept](https://digilent.com/shop/software/digilent-adept/), a legacy software

In refrence manual BPI and SPI configuration is a little bit confusing. For this locate a jumper 
with two oprion M0 and M1. There are two options for non volatile memory one is BPI other is SPI.

[RTL Schematic](../../images/FPGA_digilent_nexys3/config_table.png.png)

Jumper8 must be at 2V5 in all three cases 