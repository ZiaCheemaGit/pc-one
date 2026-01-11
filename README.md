# Aim

We all have listened phrase "A computer runs on 0 and 1s". I have spent alot
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

# PC-ONE

pc-one is an attempt to place the entire PC stack in one repository —  
hardware, kernel, operating system — all built from the ground up.

## Progress

This is where clarity starts.Follwing is the progress
what has been done in the repo and what most likely 
anyone does when they make a computer.It only includes the 
completed steps. I also dont know what are the complete steps 
so I will add as I progress  

- Make a CPU [made a single cycle RV32I with ISA(https://msyksphinz-self.github.io/riscv-isadoc/#_rv32i_rv64i_instructions)]
- Spend 5 days on making the CPU and 50 days on testing it[tested using cocotb because watching waveforms gets boring]
- Run c/cpp on cpu[done by integrating a memory(compiled by riscv64-unknown-elf) with cpu with von-neuman architecture]
- #TODO

## Next goal:
This is what is currently being tried to be done.

- dump cpu on FPGA, somehow connect it to a terminal and see print statements 

## Getting Started
Clone and explore:
```sh
git clone https://github.com/ZiaCheemaGit/pc-one.git

