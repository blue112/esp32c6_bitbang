#include "system.h"
#include <stdint.h>
#include <time.h>
#include <errno.h>

const __attribute__((weak)) __attribute__((section(".rodata_desc"))) esp_app_desc_t esp_app_desc = {
    .magic_word = 0xABCD5432,
    .version = "1",
    .project_name = "blink-bitbang",
    .idf_ver = "none",
    .secure_version = 0,
    .time = "",
    .date = "",
    .min_efuse_blk_rev_full = 0,
    .max_efuse_blk_rev_full = 99,
};

extern char _end, _eram;

static char *s_heap_start, *s_heap_end, *s_brk;

void sleep_us(int32_t us)
{
    struct timespec wait_time = {
        .tv_sec = us / 1000000,
        .tv_nsec = us % 1000000 * 1000,
    };
    while (nanosleep(&wait_time, &wait_time) == -1 && errno == EINTR)
    {
    };
}

void call_start_cpu0()
{
    s_heap_start = s_brk = &_end, s_heap_end = &_eram;
    for (char *p = &_sbss; p < &_ebss;)
        *p++ = '\0';

    wdt_disable();

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
    *REG(TIMG0_WDTWPROTECT_REG) = WDT_PROTECT_VALUE;
    *REG(TIMG1_WDTWPROTECT_REG) = WDT_PROTECT_VALUE;
    *REG(LP_WDT_RWDT_WPROTECT_REG) = WDT_PROTECT_VALUE;
    *REG(LP_WDT_SWD_WPROTECT_REG) = WDT_PROTECT_VALUE;

    *REG(LP_WDT_SWD_CONFIG_REG) |= BIT(30); // Disable
    *REG(TIMG0_WDTCONFIG0_REG) = 0;         // Disable
    *REG(TIMG1_WDTCONFIG0_REG) = 0;         // Disable
    *REG(LP_WDT_RWDT_CONFIG0_REG) = 0;      // Disable
}

void reset_watchdogs()
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
}
