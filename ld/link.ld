/* esp32_technical_reference_manual_en.pdf 1.3.2 */
MEMORY {
  drom   (rw)   : ORIGIN = 0X3ff90000, LENGTH = 64k
  irom   (rwx)  : ORIGIN = 0x40000000, LENGTH = 384k

  iram   (rwx)  : ORIGIN = 0x50000000, LENGTH = 16k  /* First 1k is vectors */
  dram   (rw)   : ORIGIN = 0x40800000, LENGTH = 512k
}

_eram = ORIGIN(dram) + LENGTH(dram);
ENTRY(call_start_cpu0)

SECTIONS {
  .text     : { *(.text*) *(.text)  } > iram

  .data : {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    *(.rodata)
    *(.rodata*)
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    . = ALIGN(4);
    _edata = .;
  } > dram

  .bss : {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } > dram

  . = ALIGN(4);
  PROVIDE(end = .);
  PROVIDE(_end = .);

  /*
  /DISCARD/ : { *(.debug) *(.debug*) *(.xtensa.*) *(.comment) }
  */
}
PROVIDE ( printf = 0x40000028 );
PROVIDE ( esp_rom_printf = 0x40000028 );
PROVIDE (uart_tx_one_char = 0x40000058);
PROVIDE (uart_tx_one_char2 = 0x4000005c);
PROVIDE (uart_rx_one_char = 0x40000060);
PROVIDE (uart_rx_one_char_block = 0x40000064);
PROVIDE (esp_rom_get_reset_reason = 0x40000018);


PROVIDE(esp_rom_newlib_init_common_mutexes = 0x400004a4);
PROVIDE(memset = 0x400004a8);
PROVIDE(memcpy = 0x400004ac);
PROVIDE(memmove = 0x400004b0);
PROVIDE(memcmp = 0x400004b4);
PROVIDE(strcpy = 0x400004b8);
PROVIDE(strncpy = 0x400004bc);
PROVIDE(strcmp = 0x400004c0);
PROVIDE(strncmp = 0x400004c4);
PROVIDE(strlen = 0x400004c8);
PROVIDE(strstr = 0x400004cc);
PROVIDE(bzero = 0x400004d0);
PROVIDE(_isatty_r = 0x400004d4);
PROVIDE(sbrk = 0x400004d8);
PROVIDE(isalnum = 0x400004dc);
PROVIDE(isalpha = 0x400004e0);
PROVIDE(isascii = 0x400004e4);
PROVIDE(isblank = 0x400004e8);
PROVIDE(iscntrl = 0x400004ec);
PROVIDE(isdigit = 0x400004f0);
PROVIDE(islower = 0x400004f4);
PROVIDE(isgraph = 0x400004f8);
PROVIDE(isprint = 0x400004fc);
PROVIDE(ispunct = 0x40000500);
PROVIDE(isspace = 0x40000504);
PROVIDE(isupper = 0x40000508);
PROVIDE(toupper = 0x4000050c);
PROVIDE(tolower = 0x40000510);
PROVIDE(toascii = 0x40000514);
PROVIDE(memccpy = 0x40000518);
PROVIDE(memchr = 0x4000051c);
PROVIDE(memrchr = 0x40000520);
PROVIDE(strcasecmp = 0x40000524);
PROVIDE(strcasestr = 0x40000528);
PROVIDE(strcat = 0x4000052c);
PROVIDE(strdup = 0x40000530);
PROVIDE(strchr = 0x40000534);
PROVIDE(strcspn = 0x40000538);
PROVIDE(strcoll = 0x4000053c);
PROVIDE(strlcat = 0x40000540);
PROVIDE(strlcpy = 0x40000544);
PROVIDE(strlwr = 0x40000548);
PROVIDE(strncasecmp = 0x4000054c);
PROVIDE(strncat = 0x40000550);
PROVIDE(strndup = 0x40000554);
PROVIDE(strnlen = 0x40000558);
PROVIDE(strrchr = 0x4000055c);
PROVIDE(strsep = 0x40000560);
PROVIDE(strspn = 0x40000564);
PROVIDE(strtok_r = 0x40000568);
PROVIDE(strupr = 0x4000056c);
PROVIDE(longjmp = 0x40000570);
PROVIDE(setjmp = 0x40000574);
PROVIDE(abs = 0x40000578);
PROVIDE(div = 0x4000057c);
PROVIDE(labs = 0x40000580);
PROVIDE(ldiv = 0x40000584);
PROVIDE(qsort = 0x40000588);
PROVIDE(rand_r = 0x4000058c);
PROVIDE(rand = 0x40000590);
PROVIDE(srand = 0x40000594);
PROVIDE(utoa = 0x40000598);
PROVIDE(itoa = 0x4000059c);
PROVIDE(atoi = 0x400005a0);
PROVIDE(atol = 0x400005a4);
PROVIDE(strtol = 0x400005a8);
PROVIDE(strtoul = 0x400005ac);
PROVIDE(fflush = 0x400005b0);
PROVIDE(_fflush_r = 0x400005b4);
PROVIDE(_fwalk = 0x400005b8);
PROVIDE(_fwalk_reent = 0x400005bc);
PROVIDE(__smakebuf_r = 0x400005c0);
PROVIDE(__swhatbuf_r = 0x400005c4);
PROVIDE(__swbuf_r = 0x400005c8);
PROVIDE(__swbuf = 0x400005cc);
PROVIDE(__swsetup_r = 0x400005d0);
PROVIDE(syscall_table_ptr = 0x4087ffd4);
PROVIDE(_global_impure_ptr = 0x4087ffd0);
