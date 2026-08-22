.section .text
    .globl bios

int_to_string:
    addi    x2, x2, -48
    sw      x1, 44(x2)
    sw      x8, 40(x2)
    addi    x8, x2, 48
    sw      x10, -36(x8)
    sw      x11, -40(x8)
    sw      x0, -20(x8)
    lw      x15, -36(x8)
    sw      x15, -24(x8)
    lw      x15, -36(x8)
    bne     x15, x0, .L_int_to_string_110
    lw      x15, -20(x8)
    lw      x14, -40(x8)
    add     x15, x14, x15
    addi    x14, x0, 48
    sb      x14, 0(x15)
    lw      x15, -20(x8)
    addi    x15, x15, 1
    sw      x15, -20(x8)
    lw      x15, -20(x8)
    lw      x14, -40(x8)
    add     x15, x14, x15
    sb      x0, 0(x15)
    jal     x0, .L_int_to_string_1b8
.L_int_to_string_bc:
    lw      x15, -24(x8)
    addi    x11, x0, 10
    addi    x10, x15, 0
    jal     x1, __modsi3
    addi    x15, x10, 0
    andi    x14, x15, 255
    lw      x15, -20(x8)
    addi    x13, x15, 1
    sw      x13, -20(x8)
    addi    x13, x15, 0
    lw      x15, -40(x8)
    add     x15, x15, x13
    addi    x14, x14, 48
    andi    x14, x14, 255
    sb      x14, 0(x15)
    lw      x15, -24(x8)
    addi    x11, x0, 10
    addi    x10, x15, 0
    jal     x1, __divsi3
    addi    x15, x10, 0
    sw      x15, -24(x8)
.L_int_to_string_110:
    lw      x15, -24(x8)
    blt     x0, x15, .L_int_to_string_bc
    lw      x15, -20(x8)
    lw      x14, -40(x8)
    add     x15, x14, x15
    sb      x0, 0(x15)
    sw      x0, -28(x8)
    jal     x0, .L_int_to_string_19c
.L_int_to_string_130:
    lw      x15, -28(x8)
    lw      x14, -40(x8)
    add     x15, x14, x15
    lbu     x15, 0(x15)
    sb      x15, -29(x8)
    lw      x14, -20(x8)
    lw      x15, -28(x8)
    sub     x15, x14, x15
    addi    x15, x15, -1
    lw      x14, -40(x8)
    add     x14, x14, x15
    lw      x15, -28(x8)
    lw      x13, -40(x8)
    add     x15, x13, x15
    lbu     x14, 0(x14)
    sb      x14, 0(x15)
    lw      x14, -20(x8)
    lw      x15, -28(x8)
    sub     x15, x14, x15
    addi    x15, x15, -1
    lw      x14, -40(x8)
    add     x15, x14, x15
    lbu     x14, -29(x8)
    sb      x14, 0(x15)
    lw      x15, -28(x8)
    addi    x15, x15, 1
    sw      x15, -28(x8)
.L_int_to_string_19c:
    lw      x15, -20(x8)
    srli    x14, x15, 0x1f
    add     x15, x14, x15
    srai    x15, x15, 0x1
    addi    x14, x15, 0
    lw      x15, -28(x8)
    blt     x15, x14, .L_int_to_string_130
.L_int_to_string_1b8:
    lw      x1, 44(x2)
    lw      x8, 40(x2)
    addi    x2, x2, 48
    jalr    x0, 0(x1)

bios:
    addi    x2, x2, -32
    sw      x1, 28(x2)
    sw      x8, 24(x2)
    addi    x8, x2, 32
    addi    x15, x8, -28
    addi    x11, x15, 0
    addi    x10, x0, 129
    jal     x1, int_to_string
    lbu     x14, -28(x8)
    addi    x15, x0, 49
    bne     x14, x15, .L_bios_228
    lbu     x14, -27(x8)
    addi    x15, x0, 50
    bne     x14, x15, .L_bios_228
    lbu     x14, -26(x8)
    addi    x15, x0, 57
    bne     x14, x15, .L_bios_228
    lbu     x15, -25(x8)
    bne     x15, x0, .L_bios_228
    lui     x15, 0x2
    lui     x14, 0xaaaab
    addi    x14, x14, -1366     # 0xaaaaaaaa
    sw      x14, 0(x15)
    jal     x0, .L_bios_268
.L_bios_228:
    lui     x15, 0x2
    lui     x14, 0xbbbbc
    addi    x14, x14, -1093     # 0xbbbbbbbb
    sw      x14, 0(x15)
    lbu     x14, -28(x8)
    lui     x15, 0x2
    addi    x15, x15, 4
    sw      x14, 0(x15)
    lbu     x14, -27(x8)
    lui     x15, 0x2
    addi    x15, x15, 8
    sw      x14, 0(x15)
    lbu     x14, -26(x8)
    lui     x15, 0x2
    addi    x15, x15, 12
    sw      x14, 0(x15)
.L_bios_268:
    addi    x15, x0, 0
    addi    x10, x15, 0
    lw      x1, 28(x2)
    lw      x8, 24(x2)
    addi    x2, x2, 32
    jalr    x0, 0(x1)

__divsi3:
    blt     x10, x0, .L_2e0
    blt     x11, x0, .L_2f0

__hidden___udivsi3:
    addi    x12, x11, 0
    addi    x11, x10, 0
    addi    x10, x0, -1
    beq     x12, x0, .L_2cc
    addi    x13, x0, 1
    bgeu    x12, x11, .L_2b0
.L_2a0:
    bge     x0, x12, .L_2b0
    slli    x12, x12, 0x1
    slli    x13, x13, 0x1
    bltu    x12, x11, .L_2a0
.L_2b0:
    addi    x10, x0, 0
.L_2b4:
    bltu    x11, x12, .L_2c0
    sub     x11, x11, x12
    or      x10, x10, x13
.L_2c0:
    srli    x13, x13, 0x1
    srli    x12, x12, 0x1
    bne     x13, x0, .L_2b4
.L_2cc:
    jalr    x0, 0(x1)

__umodsi3:
    addi    x5, x1, 0
    jal     x1, __hidden___udivsi3
    addi    x10, x11, 0
    jalr    x0, 0(x5)
.L_2e0:
    sub     x10, x0, x10
    blt     x0, x11, .L_2f4
    sub     x11, x0, x11
    jal     x0, __hidden___udivsi3
.L_2f0:
    sub     x11, x0, x11
.L_2f4:
    addi    x5, x1, 0
    jal     x1, __hidden___udivsi3
    sub     x10, x0, x10
    jalr    x0, 0(x5)

__modsi3:
    addi    x5, x1, 0
    blt     x11, x0, .L_31c
    blt     x10, x0, .L_324
.L_310:
    jal     x1, __hidden___udivsi3
    addi    x10, x11, 0
    jalr    x0, 0(x5)
.L_31c:
    sub     x11, x0, x11
    bge     x10, x0, .L_310
.L_324:
    sub     x10, x0, x10
    jal     x1, __hidden___udivsi3
    sub     x10, x0, x11
    jalr    x0, 0(x5)

    .section .rodata
    .align 2
g3_addr:
    .word 0x00002000