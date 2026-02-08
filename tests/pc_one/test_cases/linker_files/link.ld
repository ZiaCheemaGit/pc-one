OUTPUT_ARCH(riscv)
ENTRY(_start)

PROVIDE(_ram_base = ORIGIN(RAM));

/* ================= MEMORY MAP ================= */
MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 8K
    RAM (rwx) : ORIGIN = 0x00002000, LENGTH = 8K
}

/* ================= SECTIONS ================= */
SECTIONS
{
    /* ---------- CODE & CONST DATA IN ROM ---------- */
    .text :
    {
        *(.text.init)
        *(.text*)
        *(.rodata*)
        *(.srodata*)
    } > ROM

    /* ---------- INITIALIZED DATA (RUN IN RAM, LOAD FROM ROM) ---------- */
    .data : AT (LOADADDR(.text) + SIZEOF(.text))
    {
        _sdata = .;
        *(.data*)
        *(.sdata*)
        _edata = .;
    } > RAM

    _sidata = LOADADDR(.data);

    /* ---------- ZERO-INIT DATA IN RAM ---------- */
    .bss (NOLOAD) :
    {
        _sbss = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
        _ebss = .;
    } > RAM

    /* ---------- STACK ---------- */
    PROVIDE(_stack_top = ORIGIN(RAM) + LENGTH(RAM));
}
