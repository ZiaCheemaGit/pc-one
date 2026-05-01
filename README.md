![CI](https://github.com/ZiaCheemaGit/pc-one/actions/workflows/build-test.yml/badge.svg)
![License](https://img.shields.io/github/license/ZiaCheemaGit/pc-one?style=for-the-badge)

*This project is under development. Regardless feel free to contribute*

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
there will be a complete end to end design which can be directly dumped on an FPGA. For this project currently I am using Digilent Nexys3
but you can use any FPGA. Even, I myself will switch to another board. You just need a constraint file to port any project from one FPGA 
board to another one . Connect a mouse, a keyboard and a vga display to the FPGA and PC will be alive. The custom written OS will be linux 
inspired but obviously very small in comparison. That OS will be tailored to pc-one only and focus on getting max performance out of 
the custom made system.

PC-One will support 
- USB Booting
- Linux Support
- Internet Connectivity
- VGA Display
- USB Hub Support 

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

- Before start to build anything, get a good understanding theoretically. Starting right away is OK but a little theory will make the process easier. One of best resources I found was [Nand to Tetris](https://www.nand2tetris.org/). 
- If you are computer student, or even if not, you must have heard `CPU is the brain of any computer`. Thats where we can start. I made a single cycle RV32I with this [ISA](https://msyksphinz-self.github.io/riscv-isadoc/#_rv32i_rv64i_instructions). It is the base RISC-V CPU and should be an adequate start, later we might have to pipeline it, and surely will need to add extensions to it. [Refrence](https://rpsene.github.io/riscv-extensions-landscape/).
- After you make a CPU. You must verify that it does what it needs to do. This is a very crucial part. There are two types of tests, custom written verification tests to ensure my system works as I intended, and standardized community written certification tests to prove architectural consistency.Literally I spent 5 days on making the CPU and 50 days on testing it , I tested using [cocotb](https://www.cocotb.org/) because watching waveforms gets boring. I just tested the cpu with my custom written verification tests. 
- At this point we must add CI to project , [nox](https://nox.thea.codes/en/stable/) and [github actions](https://github.com/features/actions) used for this project. All tests in Dir `tests/` are ran before merge. This ensures that whenever new functionality is added, it doesn't break what already worked. See more [here](https://www.redhat.com/en/topics/devops/what-is-ci-cd)
- RV32I supports c/cpp. After successfully testing the cpu core. I ran c/cpp code on it. For this I had to integrate CPU with a memory. The C code was compiled and converted to a hex file using [riscv-unknown-elf-gcc](https://github.com/riscv-collab/riscv-gnu-toolchain). That hex file was pre-loaded into the memory.  
- At this point I started working on first I/O device. Core of Debugging is print statements. For this sake I decided to implement UART and see c/cpp print statements over it. Only after that we can move any further      
- Then learn about [UART](https://digilent.com/blog/uart-explained/?srsltid=AfmBOooOWkUeD289G3AGz7XpwJ_4cPnZfhXwZAYZa62Rj4YD0beE04W1) and [Memory Mapped IO](https://www.geeksforgeeks.org/computer-organization-architecture/memory-mapped-i-o-and-isolated-i-o/) concepts and also UART cannot be added without [MMU](https://wiki.osdev.org/Memory_Management_Unit)(not a real MMU, just a very basic one). At this point I got C code printing to a terminal but all in simulation. I made a `UART Terminal Simulator` using cocotb. That terminal simulator is also used in CI tests. 
- Uptill now everything was in simulation. Now you must learn about [FPGAs](https://en.wikipedia.org/wiki/Field-programmable_gate_array). Simulation testing isn't enough. Stakes are very high, even one wire if not on/off as intended can break everything and FPGA reveals alot more than mere simulation).  
- When I programmed my design on FPGA it required two changes i.e division of memory in ram(data memory) and rom(instruction memory). Other thing was FPGA(nexys3) support 32 bits array memory not byte addressable memory(RISCV) verilog design. UART timimg also required some changes. After all these changes my design was succesfully programmed on FPGA. But all my previously written simulation cocotb tests started failing because of this architectural change in memory(ram/rom). All tests had to be re-written. Even  after that c/cpp terminal prints didn't work on FPGA. In short what works in simulation doesn't always work on hardware. Its best to run your design on hardware in parallel to development.
- At last UART works and I can see c/cpp prints on a physical terminal i.e [minicom](https://linux.die.net/man/1/minicom). Problem was that in cocotb clock frequency can be simulated to be anything and design will be simulated regradless of clk frequency but on FPGA a single cycle rv32i cannot run above the time required by the longest instruction. Here is a [demo video](https://youtu.be/YHuOQX06mLM?si=AHQMabuc4YgpbC6A).
[![Hello World from pc-one over UART on Nexys3](images/youtube/M1.png)](https://youtu.be/YHuOQX06mLM?si=AHQMabuc4YgpbC6A)

### Milestone 02 (Boot over UART)

- At this point I am a bit lost and confused. Can't decide between `cpu traps` and `VGA` or maybe I should entirely do something else. Here is some [advice](https://forum.osdev.org/viewtopic.php?t=58078) I got from OSDev Community which is actually worth alot because from there I got introduced to concept of DMA and booting over UART to skip hassle of FPGA Re-configuration when changes are software only.
- For this milestone I decided to implement VGA. It had heavy software dependency, just to show a blank white screen alot of C code had to be written and on bare metal it is not the case that you can run the code and see output on termianl of your computer. I had to repeat `edit C code and compile into hex--> reconfig FPGA because now rom contents are changed(It took about 8 minutes to generate a bit file) --> output(See VGA screen output)`. Thus I changed milestone02 to Add boot capability over UART. This will change flow to `edit C code --> compile that code on my machine in seconds --> push a switch on FPGA and new C code will run` 
- Learn about BIOS, bootloader, OS , their responsibilities and how these three load and execute. This is crucial to support booting over UART. See this [video](https://youtu.be/XpFsMB6FoOs?si=iKalRxdDKPQcJu4N). Idea is to copy uart incoming data to ram and then move the control i.e. [program counter's](https://en.wikipedia.org/wiki/Program_counter) next read address to the location in ram where uart data was copied. Here is some terminology. The C code which is precompiled into ram is called BIOS/firmware. After that a bootloader executes. And finally OS takes control. To support UART incoming data, implement UART RX.
- Also, this a good point for a cleanup and optimizations. I analyzed ISE console all warnings, how it synthesized design, which parts took longer and after fixing these and doing some memory optimizations I was able to bring `bit file generation time` from `8 minutes` to `3 minutes`. Also reduced LUT usage from `5400/9112(total LUTs)` to `3550/9112`. AS cpu is single cycle, ram memory read logic is made combinational rather than synchronus to support data read in same cycle, when cpu requests it. Thus, this ram maps to memory as LUTs. This ram, if made synchronus, will map to BRAM. This can further decrease LUT usage. To solve this problem CPU must be pipelined as data will be available one cycle after it is requested.
- Now understand [pipelining](https://en.wikipedia.org/wiki/Instruction_pipelining) concept and what problems it solve. How it solve synchronus read, increase maximum frequency at which CPU can run e.t.c. For a high level view see this [video](https://youtu.be/1U4v_2J0Qwk?si=WOSo4rIQH2Y1EOng). After that you can see this [video](https://youtu.be/iL37v8Nlqvk?si=XeIj54lR8vLJZEaH) for a deeper view.
- An insight, any program will end up loading in ram for execution and ram, rather than just data memory, will also have to act as the instruction memory. A single port ram cannot support instruction-fetch and data-write in same cycle. This is a problem that came to my mind even before I implemented pipelining. This might need L1 cache. But I can't say anything at this point. We will see how it goes after pipelining the processor. Also I think we must run architectural certification tests before pipelining.   
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



