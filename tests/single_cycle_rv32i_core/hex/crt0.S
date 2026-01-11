.section .text.init
.global _start

_start:
    /* 1. Set the Stack Pointer to the top of RAM */
    la sp, _stack_top

    /* 2. (Optional) Clear the Frame Pointer */
    addi fp, zero, 0

    /* 3. Jump to C code */
    call main

    /* 4. Trap here if main returns (should not happen) */
loop:
    j loop
