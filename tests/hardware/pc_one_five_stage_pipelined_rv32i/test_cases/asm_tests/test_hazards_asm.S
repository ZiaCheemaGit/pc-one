# When test ends
# reg x1 == 0xCAFEBBAE TEST PASSES
# reg x1 == 0xDEADCEEF BUG in CPU (some instruction failed)
# reg x1 == 0xXXXXXXXX BUG in memory system / store path

    .section .text
    .globl bios

bios:
    # Setup base address for memory test
    .extern _ram_base
    la    x1, _ram_base
    addi  x1, x1, 0x100        # x1 = RAM_BASE + 0x100

    # PHASE 1: Control Hazards (IF/ID Flush Tests)
    
    # Test 1A: Branch Flush
    # If the IF/ID register is NOT flushed when a branch is taken, 
    # the ghost instruction below it will execute and corrupt x2.
    addi  x2, x0, 1            # x2 = 1
    addi  x3, x0, 1            # x3 = 1
    beq   x2, x3, CTRL_PASS_1  # Branch taken!
    addi  x2, x0, 99           # GHOST INSTRUCTION: MUST BE FLUSHED!
CTRL_PASS_1:
    addi  x4, x0, 1
    bne   x2, x4, FAIL         # If x2 == 99, flush failed!

    # Test 1B: Jump Flush
    # Same as above, ensuring JAL also successfully flushes IF/ID.
    addi  x2, x0, 1            # x2 = 1
    jal   x5, CTRL_PASS_2      # Jump taken!
    addi  x2, x0, 99           # GHOST INSTRUCTION: MUST BE FLUSHED!
CTRL_PASS_2:
    addi  x4, x0, 1
    bne   x2, x4, FAIL         # If x2 == 99, flush failed!

    # Test 1C: Branch Not Taken (Should NOT Flush)
    # Ensure a non-taken branch doesn't accidentally stall or flush valid data.
    addi  x2, x0, 1
    addi  x3, x0, 0
    bne   x2, x3, CTRL_PASS_3  # Taken
    j     FAIL
CTRL_PASS_3:
    beq   x2, x3, FAIL         # Not taken!
    addi  x6, x0, 42           # Valid instruction, must execute
    addi  x4, x0, 42
    bne   x6, x4, FAIL

    # PHASE 2: EX/MEM Data Hazards (Distance 1 / Back-to-Back)
    
    # Test 2A: Back-to-back arithmetic dependency
    # x7 is calculated. The very next instruction needs x7.
    # If Hazard Unit doesn't stall, x8 will grab the old x7 (which is 0).
    addi  x7, x0, 10           # Calculate x7
    addi  x8, x7, 5            # USE x7. Needs 2 cycles of stalls!
    addi  x4, x0, 15
    bne   x8, x4, FAIL         # If x8 is 5 (0+5), EX/MEM stall failed!

    # Test 2B: Register-to-Register (rs1 and rs2)
    addi  x9, x0, 10
    addi  x10, x0, 20
    add   x11, x9, x10        
    addi  x4, x0, 30
    bne   x11, x4, FAIL

    # PHASE 3: MEM/WB Data Hazards (Distance 2 & 3)

    # Test 3A: Distance 2 Dependency
    # Data is in MEM/WB when needed by Decode.
    addi  x12, x0, 50
    addi  x13, x12, 5          
    addi  x4, x0, 55
    bne   x13, x4, FAIL        # If x13 is 5 (0+5), MEM/WB stall failed!

    # Test 3B: Load-Use Hazard
    # Tests reading from Data RAM (MEM) and immediately using it.
    addi  x14, x0, 100
    sw    x14, 8(x1)           # Store 100 to RAM
    lw    x15, 8(x1)           # Load 100 to x15
    addi  x16, x15, 10         # USE x15 immediately! Needs stalling.
    addi  x4, x0, 110
    bne   x16, x4, FAIL        # If x16 is 10 (0+10), Load-Use stall failed!

    # -----------------------------------------------------------------
    # PHASE 3 EXTREME: Multi-Stage Dependency Stress Test
    # -----------------------------------------------------------------
    
    # This ensures your Hazard unit correctly prioritizes the most recent
    # register value when multiple instructions write to the same register.
    addi  x17, x0, 1           # Oldest x17 (Distance 3)
    addi  x17, x0, 2           # Older x17  (Distance 2)
    addi  x17, x0, 3           # Newest x17 (Distance 1)
    addi  x18, x17, 10         # MUST grab the '3', not the 1 or 2!
    addi  x4, x0, 13
    bne   x18, x4, FAIL        # If x18 != 13, Hazard prioritization failed!

    # If we made it here without jumping to FAIL, all hazard units work!
    j PASS


    # -----------------------------------------------------------------
    # END STATES (PASS / FAIL / HALT)
    # -----------------------------------------------------------------

FAIL:
    # Generates 0xDEADCEEF
    lui   x27, 0xDEADC
    addi  x27, x27, -0x411     # -1041 (0xEEF signed)
    sw    x27, 4(x1)           # Store to memory
    j CHECK

PASS:
    # Generates 0xCAFEBBAE
    lui   x27, 0xCAFEC         # upper = (0xCAFEBABE + 0x800) >> 12
    addi  x27, x27, -0x452     # -1106 (0xBAE signed)
    
    # Store to memory and immediately read back to verify RAM isn't broken
    sw    x27, 4(x1)
    lw    x28, 4(x1)
    
    # If the read-back fails, bypass CHECK so x1 retains whatever garbage 
    # it loaded, yielding the "0xXXXXXXXX" memory bug state.
    bne   x27, x28, CHECK_MEM_BUG 
    j CHECK

CHECK:
    lw    x1, 4(x1)            # x1 = final result loaded from RAM

CHECK_MEM_BUG:
    # If we branched here, memory read/write is broken. 
    # x1 will contain whatever was left in it.
    j HALT

HALT:
    j HALT