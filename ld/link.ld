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

/* libgcc */
PROVIDE(__absvdi2 = 0x40000884);
PROVIDE(__absvsi2 = 0x40000888);
PROVIDE(__adddf3 = 0x4000088c);
PROVIDE(__addsf3 = 0x40000890);
PROVIDE(__addvdi3 = 0x40000894);
PROVIDE(__addvsi3 = 0x40000898);
PROVIDE(__ashldi3 = 0x4000089c);
PROVIDE(__ashrdi3 = 0x400008a0);
PROVIDE(__bswapdi2 = 0x400008a4);
PROVIDE(__bswapsi2 = 0x400008a8);
PROVIDE(__clear_cache = 0x400008ac);
PROVIDE(__clrsbdi2 = 0x400008b0);
PROVIDE(__clrsbsi2 = 0x400008b4);
PROVIDE(__clzdi2 = 0x400008b8);
PROVIDE(__clzsi2 = 0x400008bc);
PROVIDE(__cmpdi2 = 0x400008c0);
PROVIDE(__ctzdi2 = 0x400008c4);
PROVIDE(__ctzsi2 = 0x400008c8);
PROVIDE(__divdc3 = 0x400008cc);
PROVIDE(__divdf3 = 0x400008d0);
PROVIDE(__divdi3 = 0x400008d4);
PROVIDE(__divsc3 = 0x400008d8);
PROVIDE(__divsf3 = 0x400008dc);
PROVIDE(__divsi3 = 0x400008e0);
PROVIDE(__eqdf2 = 0x400008e4);
PROVIDE(__eqsf2 = 0x400008e8);
PROVIDE(__extendsfdf2 = 0x400008ec);
PROVIDE(__ffsdi2 = 0x400008f0);
PROVIDE(__ffssi2 = 0x400008f4);
PROVIDE(__fixdfdi = 0x400008f8);
PROVIDE(__fixdfsi = 0x400008fc);
PROVIDE(__fixsfdi = 0x40000900);
PROVIDE(__fixsfsi = 0x40000904);
PROVIDE(__fixunsdfsi = 0x40000908);
PROVIDE(__fixunssfdi = 0x4000090c);
PROVIDE(__fixunssfsi = 0x40000910);
PROVIDE(__floatdidf = 0x40000914);
PROVIDE(__floatdisf = 0x40000918);
PROVIDE(__floatsidf = 0x4000091c);
PROVIDE(__floatsisf = 0x40000920);
PROVIDE(__floatundidf = 0x40000924);
PROVIDE(__floatundisf = 0x40000928);
PROVIDE(__floatunsidf = 0x4000092c);
PROVIDE(__floatunsisf = 0x40000930);
PROVIDE(__gcc_bcmp = 0x40000934);
PROVIDE(__gedf2 = 0x40000938);
PROVIDE(__gesf2 = 0x4000093c);
PROVIDE(__gtdf2 = 0x40000940);
PROVIDE(__gtsf2 = 0x40000944);
PROVIDE(__ledf2 = 0x40000948);
PROVIDE(__lesf2 = 0x4000094c);
PROVIDE(__lshrdi3 = 0x40000950);
PROVIDE(__ltdf2 = 0x40000954);
PROVIDE(__ltsf2 = 0x40000958);
PROVIDE(__moddi3 = 0x4000095c);
PROVIDE(__modsi3 = 0x40000960);
PROVIDE(__muldc3 = 0x40000964);
PROVIDE(__muldf3 = 0x40000968);
PROVIDE(__muldi3 = 0x4000096c);
PROVIDE(__mulsc3 = 0x40000970);
PROVIDE(__mulsf3 = 0x40000974);
PROVIDE(__mulsi3 = 0x40000978);
PROVIDE(__mulvdi3 = 0x4000097c);
PROVIDE(__mulvsi3 = 0x40000980);
PROVIDE(__nedf2 = 0x40000984);
PROVIDE(__negdf2 = 0x40000988);
PROVIDE(__negdi2 = 0x4000098c);
PROVIDE(__negsf2 = 0x40000990);
PROVIDE(__negvdi2 = 0x40000994);
PROVIDE(__negvsi2 = 0x40000998);
PROVIDE(__nesf2 = 0x4000099c);
PROVIDE(__paritysi2 = 0x400009a0);
PROVIDE(__popcountdi2 = 0x400009a4);
PROVIDE(__popcountsi2 = 0x400009a8);
PROVIDE(__powidf2 = 0x400009ac);
PROVIDE(__powisf2 = 0x400009b0);
PROVIDE(__subdf3 = 0x400009b4);
PROVIDE(__subsf3 = 0x400009b8);
PROVIDE(__subvdi3 = 0x400009bc);
PROVIDE(__subvsi3 = 0x400009c0);
PROVIDE(__truncdfsf2 = 0x400009c4);
PROVIDE(__ucmpdi2 = 0x400009c8);
PROVIDE(__udivdi3 = 0x400009cc);
PROVIDE(__udivmoddi4 = 0x400009d0);
PROVIDE(__udivsi3 = 0x400009d4);
PROVIDE(__udiv_w_sdiv = 0x400009d8);
PROVIDE(__umoddi3 = 0x400009dc);
PROVIDE(__umodsi3 = 0x400009e0);
PROVIDE(__unorddf2 = 0x400009e4);
PROVIDE(__unordsf2 = 0x400009e8);
PROVIDE(__extenddftf2 = 0x400009ec);
PROVIDE(__trunctfdf2 = 0x400009f0);
