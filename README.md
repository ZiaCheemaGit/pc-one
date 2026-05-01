![CI](https://github.com/ZiaCheemaGit/pc-one/actions/workflows/build-test.yml/badge.svg)
![License](https://img.shields.io/github/license/ZiaCheemaGit/pc-one?style=for-the-badge)

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

The goal is to make a computer understandable end-to-end. 

Atleast for now the aim is to make a complete PC starting from on off electrical signals 
upto to an OS running applications. 

At the end(if that ever happens) we will have a project in which 
there will be a complete end to end design which can be directly dumped on an FPGA. For this project I am using Digilent Nexys3
but you can use any FPGA. 
Connect a mouse, a keyboard and a vga display to the FPGA and PC will be alive. The OS will be linux inspired
but very small. Just a terminal.

---

# NOTE
This branch is an education focused contribution. It isn't an industry standard nor the most performance or silicon optimized solution. 
I might create a new fork or a new branch. However if I do any thing on this in future I will add the link to it here. 

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

### MileStone 01 (Hello World over UART)

- Get a good understanding of bare metal systems. One of best resources I found was [Nand to Tetris](https://www.nand2tetris.org/).
- Make a CPU , I made a single cycle RV32I with this [ISA](https://msyksphinz-self.github.io/riscv-isadoc/#_rv32i_rv64i_instructions).
- Spend 5 days on making the CPU and 50 days on testing it , I tested using [cocotb](https://www.cocotb.org/) because watching waveforms gets boring.
- Add CI to project , [nox](https://nox.thea.codes/en/stable/) and [github actions](https://github.com/features/actions) used for this project. All tests in Dir `tests/` are ran before merge.
- Run c/cpp on cpu this is done by integrating a rom memory(compiled by riscv64-unknown-elf) with cpu.
- At this point start working on first I/O device. Core of Debugging is print statements. For this sake I decided to implement UART and see c/cpp print statements over it.       
- Learn [UART](https://digilent.com/blog/uart-explained/?srsltid=AfmBOooOWkUeD289G3AGz7XpwJ_4cPnZfhXwZAYZa62Rj4YD0beE04W1) and [Memory Mapped IO](https://www.geeksforgeeks.org/computer-organization-architecture/memory-mapped-i-o-and-isolated-i-o/) Concepts because UART cannot be added without [MMU](https://wiki.osdev.org/Memory_Management_Unit). 
- Learn about [FPGAs](https://en.wikipedia.org/wiki/Field-programmable_gate_array). Simulation testing isn't enough(Stakes are very high, even one wire if not on/off as intended can break everything).  
- First I tested c/cpp code UART prints on cocotb in simulation. When I programmed my design on FPGA it required two changes i.e division of memory in ram(data memory) and rom(instruction memory). Other thing was FPGA(nexys3) support 32 bits array memory not byte addressable memory(RISCV). UART timimg also required some changes. After all these changes my design was succesfully programmed on FPGA. But all my previously written simulation cocotb tests started failing. All tests had to be re-written. Even  after that c/cpp terminal prints didn't work on FPGA. In short what works in simulation doesn't always work on hardware. Its best to run your design on hardware in parallel to development.
- At last UART works and I can see c/cpp prints on a physical terminal i.e [minicom](https://linux.die.net/man/1/minicom). Problem was that in cocotb clock frequency can be simulated to be anything and design will be simulated regradless of clk frequency but on FPGA a single cycle rv32i cannot run above the time required by the longest instruction. Here is a [demo video](https://youtu.be/YHuOQX06mLM?si=AHQMabuc4YgpbC6A).
[![Hello World from pc-one over UART on Nexys3](images/youtube/M1.png)](https://youtu.be/YHuOQX06mLM?si=AHQMabuc4YgpbC6A)

### Milestone 02 (Boot over UART)

- At this point I am a bit lost and confused. Can't decide between `cpu traps` and `VGA` or maybe I should entirely do something else. Here is some [advice](https://forum.osdev.org/viewtopic.php?t=58078) I got from OSDev Community which is actually worth alot because from there I got introduced to concept of DMA and booting over UART to skip hassle of FPGA Re-configuration when changes are software only. After that VGA can be completed.
- For this milestone I decided to implement VGA. It has heavy software dependency, just to show a blank white screen I had to repeat `edit c files --> reconfig FPGA(8 mins per bitgen file) --> test`. Thus I changed milestone02 to Add boot capability over UART.  
- Learn about BIOS, bootloader, OS , their responsibilities and how these three load and execute. This is crucial to support booting over UART. See this [video](https://youtu.be/XpFsMB6FoOs?si=iKalRxdDKPQcJu4N)
- Implement UART rx. Also, this a good point for a cleanup and optimizations. After uart rx implementation I analyzed ISE console all warnings, how it synthesized design, which parts took longer and after fixing these and doing some memory optimizations I was able to bring `bitgen time` from `8 minutes` to `3 minutes`. Also reduced LUT usage from `5400/9112(total LUTs)` to `3550/9112`. Currently ram read is combinational rather than synchronus to support data read in same cycle, when cpu requests data becasue cpu is single cycle. Thus, this ram maps to memory as LUTs. This ram, if made synchronus, will map to BRAM. This can further decrease LUT usage. But then CPU must be pipelined as data will be available one cycle after it is requested.
- Another very important thing is program(i.e. bootloader) loaded via UART will be downloaded into ram and then execute that. UART bootloader aside, In future any program will end up loading in ram for execution. A single port ram cannot support instruction-fetch and data-write in same cycle. This is another very strong reason for cpu to be made pipelined.  
- Now understand [pipelining](https://en.wikipedia.org/wiki/Instruction_pipelining) concept and what problems it solve. How it solve synchronus read, increase maximum frequency at which CPU can run e.t.c. For a high level view see this [video](https://youtu.be/1U4v_2J0Qwk?si=WOSo4rIQH2Y1EOng). After that you can see this [video](https://youtu.be/iL37v8Nlqvk?si=XeIj54lR8vLJZEaH) for a deeper insight.
- Single cycle RV32I occupied `2300 LUTs`.
-
- TODO  

## Next Milestones:
This is what is currently being tried to be done.
- pipeline cpu
- Add DMA
- implement cpu traps
- Add VGA
---

# Getting Started
Clone and explore:
```sh
git clone https://github.com/ZiaCheemaGit/pc-one.git
```
In all directories and sub directories there is a `README.md`. These readme files hopefully will 
help anyone at the beginning to get a fair amount of clarity. After getting an overview through 
these one can dive into source code.

---

# Contributing

This is definitely a huge project. Pull requests, ideas, and corrections are welcome from anyone who shares the vision.



