PROG        ?= firmware
CFLAGS      ?= -W -Wall -Wextra -Wundef -Wshadow -pedantic -march=rv32imac_zicsr_zifencei -fdiagnostics-color=always -ffunction-sections -fdata-sections -Wdouble-promotion -fno-common -Wconversion
LINKFLAGS   ?= --specs=nosys.specs -Tld/link.ld -nostdlib -nostartfiles -Wl,--gc-sections $(EXTRA_LINKFLAGS)
CWD         ?= $(realpath $(CURDIR))
FLASH_ADDR  ?= 0x0  # 2nd stage bootloader flash offset
TOOLCHAIN   ?= /home/blue/.espressif/tools/riscv32-esp-elf/esp-13.2.0_20240530/riscv32-esp-elf/bin/riscv32-esp-elf
SRCS        ?= system.c main.c

build: build/$(PROG).bin

build/$(PROG).elf: $(SRCS)
	$(TOOLCHAIN)-gcc $(CFLAGS) $(SRCS) $(LINKFLAGS) -o $@

bin/esputil: bin/esputil.c
	gcc -o bin/esputil bin/esputil.c

build/$(PROG).bin: build/$(PROG).elf bin/esputil
	bin/esputil mkbin build/$(PROG).elf $@

flash: build/$(PROG).bin
	bin/esputil -p /dev/ttyACM* flash 0x0 $<

monitor:
	@echo "=== MONITORING START"
	bin/esputil -p /dev/ttyACM* monitor

clean:
	-rm build/*
