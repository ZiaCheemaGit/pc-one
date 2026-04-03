/* Architecture */
OUTPUT_ARCH(riscv)

/* Entry point */
ENTRY(_start)


MEMORY
{
    ROM (rx)  : ORIGIN = 0x0, LENGTH = 0x500
    RAM (rwx) : ORIGIN = 0x2000, LENGTH = 0x800
}

/* Universal Variables */
PROVIDE(_ram_base = ORIGIN(RAM));
_stack_top = ORIGIN(RAM) + LENGTH(RAM);

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

