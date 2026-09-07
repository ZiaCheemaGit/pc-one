OUTPUT_ARCH(riscv)
ENTRY(rvtest_entry_point)

MEMORY
{
    ram (rwx) : ORIGIN = 0x0, LENGTH = 0x200000 /* 2MB flat memory */
}

TEST_BASE = ORIGIN(ram);
PROVIDE(__stack_size = 0x10000); /* 64KB stack */
PROVIDE(__num_harts = 1);

SECTIONS
{
    .text.init TEST_BASE : { *(.text.init) } > ram
    .text.rvtest . : { *(.text.rvtest) *(.text.rvtest.*) } > ram
    
    .text : { 
        *(.text*) 
        *(.rodata*) 
        *(.srodata*) 
    } > ram

    . = ALIGN(0x1000);
    .data : {
        _sdata = .;
        *(.data) *(.data.*) *(.sdata) *(.sdata.*)
        _edata = .;
    } > ram

    .bss (NOLOAD) : {
        __bss_start = .;
        *(.bss*) *(.sbss*) *(COMMON)
        __bss_end = .;
    } > ram

    . = ALIGN(16);
    __stack_bottom = .;
    . += __stack_size * __num_harts;
    __stack_top = .;

    .text.rvmodel . : { *(.text.rvmodel) *(.text.rvmodel.*) } > ram
}
