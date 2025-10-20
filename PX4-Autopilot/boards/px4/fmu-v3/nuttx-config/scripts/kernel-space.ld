/****************************************************************************
 * kernel-space.ld for STM32F427 (Pixhawk 2.4.8)
 ****************************************************************************/

OUTPUT_ARCH(arm)
EXTERN(_vectors)
ENTRY(_stext)

EXTERN(abort)

SECTIONS
{
    .text : {
        _stext = ABSOLUTE(.);
        *(.vectors)
        . = ALIGN(32);
        /* Optional: boot delay signature if supported */
        /* _bootdelay_signature = ABSOLUTE(.); */
        /* FILL(0xffecc2925d7d05c5) */
        /* . += 8; */
        *(.text .text.*)
        *(.fixup)
        *(.gnu.warning)
        *(.rodata .rodata.*)
        *(.gnu.linkonce.t.*)
        *(.glue_7)
        *(.glue_7t)
        *(.got)
        *(.gcc_except_table)
        *(.gnu.linkonce.r.*)
        _etext = ABSOLUTE(.);
    } > kflash

    .init_section : {
        _sinit = ABSOLUTE(.);
        KEEP(*(.init_array .init_array.*))
        _einit = ABSOLUTE(.);
    } > kflash

    .ARM.extab : { *(.ARM.extab*) } > kflash
    __exidx_start = ABSOLUTE(.);
    .ARM.exidx : { *(.ARM.exidx*) } > kflash
    __exidx_end = ABSOLUTE(.);
    _eronly = ABSOLUTE(.);

    .data : {
        _sdata = ABSOLUTE(.);
        *(.data .data.*)
        *(.gnu.linkonce.d.*)
        CONSTRUCTORS
        _edata = ABSOLUTE(.);
    } > ksram AT > kflash

    .bss : {
        _sbss = ABSOLUTE(.);
        *(.bss .bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = ABSOLUTE(.);
    } > ksram

    /* Optional: place critical functions in CCM */
    /*
    .ramfunc : {
        _sramfuncs = .;
        *(.ramfunc .ramfunc.*)
        . = ALIGN(4);
        _eramfuncs = .;
    } > ccmram AT > kflash
    _framfuncs = LOADADDR(.ramfunc);
    */

    /* Debug sections */
    .stab 0 : { *(.stab) }
    .stabstr 0 : { *(.stabstr) }
    .comment 0 : { *(.comment) }
    .debug_abbrev 0 : { *(.debug_abbrev) }
    .debug_info 0 : { *(.debug_info) }
    .debug_line 0 : { *(.debug_line) }
    .debug_pubnames 0 : { *(.debug_pubnames) }
    .debug_aranges 0 : { *(.debug_aranges) }
}