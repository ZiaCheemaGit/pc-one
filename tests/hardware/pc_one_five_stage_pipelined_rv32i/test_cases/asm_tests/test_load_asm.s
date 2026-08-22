.globl bios

bios:
    # Base address
    li x1, 0x2000

    # Test data
    li x2, 0xAABBCCDD

    sb x2, 0(x1)        # 0x2000 = 0xDD
    sh x2, 4(x1)        # 0x2004 = 0xDD && 0x2005 = 0xCC 
    sw x2, 8(x1)        # 0x2008 = 0xDD && 0x2009 = 0xCC && 0x200A = 0xBB && 0x200B = 0xAA

    lw  x10, 8(x1)      # x10 = 0xAABBCCDD

    lh  x11, 4(x1)      # x11 = 0xFFFFCCDD

    lb  x12, 0(x1)      # x12 = 0xFFFFFFDD

    lbu x13, 0(x1)      # x13 = 0x000000DD

    lhu x14, 4(x1)      # x14 = 0x0000CCDD

done:
    j done
