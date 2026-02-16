# PC-ONE

pc-one is an attempt to place the entire PC stack in one repository —  
hardware, kernel, operating system — all built from the ground up.

---

# Vision

We all have listened phrase `A computer runs on 0 and 1s`. I have spent alot
of time to uncover this completely and also did to an extent. I am making this project to
- satisfy my curiosity
- facilitate any person who wants to understand computer as a complete system
- build a reference that I wish existed when I started learning

It is not about performance or production readiness.
It is just about clarity and completeness.The goal is to make a computer understandable end-to-end.

Atleast for now the aim is to make a complete PC from on off electrical signals 
upto to an OS running applications. 

At the end(if that ever happens) we will have a project in which 
there will be verilog which can be directly dumped on an FPGA.Connect a mouse,
a keyboard and a vga display to the FPGA and PC will be alive.

---

# Status

This project is under development and below is current progress
and future milestones.

## Current Progress

This is where clarity starts.Following is the progress
what has been done uptill now and what most likely 
anyone does when they make a computer.It only includes the 
completed steps. I also dont know what are the complete steps 
so I will add them here as I progress  
- Get a good understanding of bare metal systems. One of best resources I found was [Nand to Tetris](https://www.nand2tetris.org/) 
- Make a CPU , I made a single cycle RV32I with this [ISA](https://msyksphinz-self.github.io/riscv-isadoc/#_rv32i_rv64i_instructions)
- Spend 5 days on making the CPU and 50 days on testing it , I tested using cocotb because watching waveforms gets boring
- Add CI to project , nox and github actions used for this project. All tests in Dir `tests/` are ran before merge
- Run c/cpp on cpu this is done by integrating a rom memory(compiled by riscv64-unknown-elf) with cpu 
- At this point start working on first I/O device. Core of Debugging is print statements. For this sake I decided to implement UART and see c/cpp print statemetns over it.       
- Learn UART and Memory Mapped IO Concepts because UART cannot be added without MMU. 
- Learn about FPGAs. Simulation testing isn't enough(Stakes are very high, even one wire if not on/off as intended can break everything).  
- First I tested c/cpp code UART prints on cocotb in simulation. When I programmed my pc in FPGA it required two changes i.e division of memory in ram(data memory) and rom(instruction memory). Other thing was FPGA(nexys3) support 32 bits array memory not byte addressable memory(RISCV). UART timimg also required some changes. After all these changes my design succesfully programmed on FPGA. But all my previously written simulation cocotb tests started failing. All tests had to be re-written. Even  after that c/cpp terminal prints didn't work on FPGA. In short what works in simulation doesn't always work on hardware. Its best to run your design on hardware in parallel to development.
- At last UART works and I can see c/cpp prints on a physical terminal i.e minicom. Problem was that in cocotb clock frequency can be simulated to be anything and design will be simulated regradless of clk frequency but on FPGA a single cycle rv32i cannot run above the time required by the longest instruction.
-
- TODO

## Next Milestones:
This is what is currently being tried to be done.
- implement cpu traps
- Add VGA
---

# Getting Started
Clone and explore:
```sh
git clone https://github.com/ZiaCheemaGit/pc-one.git
```
In all directories and sub directories there is a `README.md`. These readme  files hopefully will 
help anyone at the beginning to get a fair amount of clarity. After getting an overview through 
these one can dive into source code.

---

# Contributing

This is definitely a huge project. Pull requests, ideas, and
corrections are welcome from anyone who shares the vision.



