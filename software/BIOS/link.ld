/* Architecture */
OUTPUT_ARCH(riscv)

/* Entry point */
ENTRY(_start)

/* Universal Variables */
PROVIDE(_ram_base = ORIGIN(RAM));
PROVIDE(_stack_top = ORIGIN(RAM) + LENGTH(RAM));

MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00000424
    RAM (rwx) : ORIGIN = 0x00002000, LENGTH = 0x00002800
}

SECTIONS
{
    .text :
    {
        *(.text.init)
        *(.text*)
        *(.rodata*)
        *(.srodata*)
    } > ROM

    .data : AT (LOADADDR(.text) + SIZEOF(.text))
    {
        _sdata = .;
        *(.data*)
        *(.sdata*)
        _edata = .;
    } > RAM

    _sidata = LOADADDR(.data);

    .bss (NOLOAD) :
    {
        _sbss = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
        _ebss = .;
    } > RAM
}

