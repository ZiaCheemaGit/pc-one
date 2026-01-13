# ram[0x104] == 0xCAFEBBAE TEST PASSES
# ram[0x104] == 0xDEADCEEF BUG in CPU (some instruction failed)
# ram[0x104] == 0xXXXXXXXX BUG in memory system / store path

    .section .text
    .globl main

main:
    # Setup base address for memory test
    lui   x1, 0x0
    addi  x1, x1, 0x100        # x1 = 0x100

    # U-type
    lui   x2, 0x12345
    auipc x3, 0                # x3 = PC

    # I-type arithmetic / logic
    addi  x4, x0, 10
    addi  x5, x0, -5

    slti  x6, x5, 0            # -5 < 0 → 1
    sltiu x7, x5, 1            # unsigned false

    andi  x8, x4, 3
    ori   x9, x8, 4
    xori  x10, x9, 7

    # Shift immediates
    slli  x11, x4, 2
    srli  x12, x11, 1
    srai  x13, x11, 1

    # R-type ALU
    add   x14, x4, x5
    sub   x15, x4, x5

    sll   x16, x4, x6
    srl   x17, x16, x6
    sra   x18, x16, x6

    slt   x19, x5, x4
    sltu  x20, x5, x4

    and   x21, x4, x6
    or    x22, x4, x6
    xor   x23, x4, x6

    # Store / Load
    sw    x15, 0(x1)
    lw    x24, 0(x1)

    bne   x15, x24, FAIL

    # Branches (taken and not taken)
    beq   x4, x5, FAIL
    bne   x4, x5, BR1
    j     FAIL

BR1:
    blt   x5, x4, BR2
    j     FAIL

BR2:
    bge   x4, x5, BR3
    j     FAIL

BR3:
    bltu  x5, x4, FAIL
    bgeu  x5, x4, BR4

BR4:

    # Jumps
    jal   x25, FUNC
    j PASS

FUNC:

    # x0 must stay zero
    addi  x0, x0, 123
    addi  x26, x0, 123
    beq   x0, x26, FAIL
    jalr  x0, x25, 0

FAIL:
    lui   x27, 0xDEADC
    addi  x27, x27, -0x411    # -1041 (0xEEF signed)
    sw    x27, 4(x1)
    j HALT

PASS:
    lui   x27, 0xCAFEC        # upper = (0xCAFEBABE + 0x800) >> 12
    addi  x27, x27, -0x452    # -1106 (0xBAE signed)
    sw    x27, 4(x1)
    lw    x28, 4(x1)
    beq   x27, x28, HALT

HALT:
    j HALT


