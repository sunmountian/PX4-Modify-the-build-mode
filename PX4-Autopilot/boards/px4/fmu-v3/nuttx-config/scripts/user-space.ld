/****************************************************************************
 * user-space.ld for STM32F427 (Pixhawk 2.4.8)
 ****************************************************************************/

EXTERN(userspace)
OUTPUT_ARCH(arm)

SECTIONS
{
    .userspace : {
        *(.userspace)
    } > uflash

    .text : {
        _stext = ABSOLUTE(.);
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
    } > uflash

    .init_section : {
        _sinit = ABSOLUTE(.);
        KEEP(*(.init_array .init_array.*))
        _einit = ABSOLUTE(.);
    } > uflash

    .ARM.extab : { *(.ARM.extab*) } > uflash
    __exidx_start = ABSOLUTE(.);
    .ARM.exidx : { *(.ARM.exidx*) } > uflash
    __exidx_end = ABSOLUTE(.);
    _eronly = ABSOLUTE(.);

    .data : {
        _sdata = ABSOLUTE(.);
        *(.data .data.*)
        *(.gnu.linkonce.d.*)
        CONSTRUCTORS
        _edata = ABSOLUTE(.);
    } > usram AT > uflash

    .bss : {
        _sbss = ABSOLUTE(.);
        *(.bss .bss.*)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        /* Align _ebss for MPU-friendly region */
        . = ALIGN(0x1000);
        _ebss = ABSOLUTE(.);
    } > usram

    /* Image signature at end (for bootloader verification) */
    .signature : {
        _boot_signature = ALIGN(4);
    } > uflash

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