OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
  RAM (rwx) : ORIGIN = 0x00000000, LENGTH = 8K
}

SECTIONS
{
  . = 0x00000000; 

  .text : 
  {
    *(.text.init) 
    *(.text)      
  } > RAM

  .data : 
  {
    *(.data)
  } > RAM

  .bss :
  {
    *(.bss)
  } > RAM

  PROVIDE(_stack_top = ORIGIN(RAM) + LENGTH(RAM));
}
