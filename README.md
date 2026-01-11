# Aim

Make 
Successfuly ran assembly and c/cpp programs on *single cycle RV32I*. Test programs ran using cocotb and compiled using gcc.
Next Step: Put CPU on an FPGA and make it run a ROM program after reset. 

# pc-one

A simple open-source general-purpose PC built from ground up in Verilog and RISC-V.

## Overview
pc-one implements a single-cycle RV32I CPU core and successfully runs Assembly and C/C++ programs. Tests are written using cocotb and compiled with GCC. :contentReference[oaicite:1]{index=1}

## Features
- RV32I **single-cycle CPU core**  
- Runs basic Assembly and C/C++ programs  
- Verified with cocotb tests and GCC toolchain :contentReference[oaicite:2]{index=2}

## Status
Under active development. Next goals:
- FPGA implementation
- ROM boot after reset :contentReference[oaicite:3]{index=3}

## Getting Started
Clone and explore:
```sh
git clone https://github.com/ZiaCheemaGit/pc-one.git
