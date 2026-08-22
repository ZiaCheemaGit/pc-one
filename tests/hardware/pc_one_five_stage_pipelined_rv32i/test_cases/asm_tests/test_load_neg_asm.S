.section .text
.globl bios

bios:

    li sp, 0x2800

    addi sp, sp, -16

    addi x5, x0, 54
    addi x6, x0, 52

    addi x7, sp, 8

    sb x5, -1(x7)
    sb x6, -2(x7)

    lb x8, -1(x7)
    lb x9, -2(x7)

    addi x10, x0, 54
    bne x8,x10,FAIL

    addi x10, x0, 52
    bne x9,x10,FAIL

PASS:
    lui x1,0xCAFEC
    addi x1,x1,-0x452
    j END

FAIL:
    lui x1,0xDEADC
    addi x1,x1,-0x411

END:
    j END

    