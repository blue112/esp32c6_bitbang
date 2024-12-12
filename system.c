#include "system.h"
#include <stdint.h>
#include <time.h>
#include <errno.h>

extern char _end, _eram;

static char *s_heap_start, *s_heap_end, *s_brk;

void call_start_cpu0()
{
    s_heap_start = s_brk = &_end, s_heap_end = &_eram;
    for (char *p = &_sbss; p < &_ebss;)
        *p++ = '\0';

    wdt_disable();

    spin(500000); // Few ms so we can start serial monitor

    uint32_t rst_reas = esp_rom_get_reset_reason(0);
    esp_rom_printf("Reset reason: 0x%02X\n", rst_reas);

    main();
}

volatile uint32_t *watchdog_protect_register = LP_WDT_RWDT_WPROTECT_REG;
volatile uint32_t *reset_watchdog_register = LP_WDT_RWDT_RTC_WDT_FEED;
volatile uint32_t *superwatchdog_protect_reg = LP_WDT_SWD_WPROTECT_REG;
volatile uint32_t *superwatchdog_config_register = LP_WDT_SWD_CONFIG_REG;
volatile uint32_t *timg0_wdt_protect = TIMG0_WDTWPROTECT_REG;
volatile uint32_t *timg0_wdt_feed = TIMG0_WDTFEED_REG;
volatile uint32_t *timg1_wdt_protect = TIMG1_WDTWPROTECT_REG;
volatile uint32_t *timg1_wdt_feed = TIMG1_WDTFEED_REG;

void wdt_disable()
{
    *REG(LP_WDT_RWDT_RTC_WDT_FEED) |= BIT(31);

    *REG(TIMG0_WDTWPROTECT_REG) = WDT_PROTECT_VALUE;
    *REG(TIMG1_WDTWPROTECT_REG) = WDT_PROTECT_VALUE;
    *REG(LP_WDT_RWDT_WPROTECT_REG) = WDT_PROTECT_VALUE;
    *REG(LP_WDT_SWD_WPROTECT_REG) = WDT_PROTECT_VALUE;

    *REG(LP_WDT_SWD_CONFIG_REG) |= BIT(18); // Disable
    *REG(TIMG0_WDTCONFIG0_REG) = 0;         // Disable
    *REG(TIMG1_WDTCONFIG0_REG) = 0;         // Disable
    *REG(LP_WDT_RWDT_CONFIG0_REG) = 0;      // Disable

    *REG(TIMG0_WDTWPROTECT_REG) = 0;
    *REG(TIMG1_WDTWPROTECT_REG) = 0;
    *REG(LP_WDT_RWDT_WPROTECT_REG) = 0;
    *REG(LP_WDT_SWD_WPROTECT_REG) = 0;
}

/*void reset_watchdogs()
{
    *superwatchdog_protect_reg = WDT_PROTECT_VALUE;
    *superwatchdog_config_register = *superwatchdog_config_register | BIT(31);
    *superwatchdog_protect_reg = 0;

    *watchdog_protect_register = WDT_PROTECT_VALUE;
    *reset_watchdog_register = *reset_watchdog_register | BIT(31);
    *watchdog_protect_register = 0;

    *timg0_wdt_protect = WDT_PROTECT_VALUE; // Unlock
    *timg0_wdt_feed = 0xFFFF;
    *timg0_wdt_protect = 0; // Lock

    *timg1_wdt_protect = WDT_PROTECT_VALUE; // Unlock
    *timg1_wdt_feed = 0xFFFF;
    *timg1_wdt_protect = 0; // Lock
}*/
