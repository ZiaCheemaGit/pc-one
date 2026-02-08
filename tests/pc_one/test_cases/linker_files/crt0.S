.section .text.init
.global _start

_start:
    /* 1. Set stack pointer */
    la sp, _stack_top

    /* 2. Copy .data from ROM to RAM */
    la t0, _sidata     /* source (ROM) */
    la t1, _sdata      /* dest (RAM) */
    la t2, _edata      /* end of .data */

copy_data:
    beq t1, t2, copy_data_done
    lw  t3, 0(t0)
    sw  t3, 0(t1)
    addi t0, t0, 4
    addi t1, t1, 4
    j copy_data

copy_data_done:

    /* 3. Zero .bss */
    la t0, _sbss
    la t1, _ebss

zero_bss:
    beq t0, t1, zero_bss_done
    sw  zero, 0(t0)
    addi t0, t0, 4
    j zero_bss

zero_bss_done:

    /* 4. Call main */
    call main

/* 5. If main returns, halt */
halt:
    j halt
