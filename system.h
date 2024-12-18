#pragma once

#include <stdint.h>
extern char _sbss;
extern char _ebss;

int main();

uint32_t esp_rom_get_reset_reason(int cpu_no);
int esp_rom_printf(const char *fmt, ...);

#define WATCHDOG_BASE 0x600B1C00
#define TIMG0_BASE 0x60008000
#define TIMG1_BASE 0x60009000

#define BIT(nr) (1UL << (nr))
#define REG(x) ((volatile uint32_t *)(x))

#define LP_WDT_RWDT_CONFIG0_REG ((uint32_t *)(WATCHDOG_BASE + 0x0000))
#define LP_WDT_RWDT_RTC_WDT_FEED ((uint32_t *)(WATCHDOG_BASE + 0x0014))
#define LP_WDT_SWD_CONFIG_REG ((uint32_t *)(WATCHDOG_BASE + 0x001C))
#define LP_WDT_SWD_WPROTECT_REG ((uint32_t *)(WATCHDOG_BASE + 0x0020))
#define LP_WDT_RWDT_WPROTECT_REG ((uint32_t *)(WATCHDOG_BASE + 0x0018))
#define PCR_TIMERGROUP0_TIMER_CLK_CONF_REG ((uint32_t *)(TIMG0_BASE + 0x0040))
#define TIMG_T0CONFIG_REG ((uint32_t *)(TIMG0_BASE + 0x0000))
#define TIMG0_WDTFEED_REG ((uint32_t *)(TIMG0_BASE + 0x0060))
#define TIMG0_WDTWPROTECT_REG ((uint32_t *)(TIMG0_BASE + 0x0064))
#define TIMG0_TOUPDATE_REG ((uint32_t *)(TIMG0_BASE + 0x000C))
#define TIMG0_TOLO_REG ((uint32_t *)(TIMG0_BASE + 0x0004))
#define TIMG0_TOHI_REG ((uint32_t *)(TIMG0_BASE + 0x0008))
#define TIMG1_WDTFEED_REG ((uint32_t *)(TIMG1_BASE + 0x0060))
#define TIMG1_WDTWPROTECT_REG ((uint32_t *)(TIMG1_BASE + 0x0064))
#define TIMG0_WDTCONFIG0_REG ((uint32_t *)(TIMG0_BASE + 0x0048))
#define TIMG1_WDTCONFIG0_REG ((uint32_t *)(TIMG1_BASE + 0x0048))

#define WDT_PROTECT_VALUE 0x50d83aa1

#define TRACE_BASE 0x600C0000
#define TRACE_MEM_START_ADDR_REG ((uint32_t *)(TRACE_BASE + 0x0000))
#define TRACE_MEM_END_ADDR_REG ((uint32_t *)(TRACE_BASE + 0x0004))
#define TRACE_TRIGGER_REG ((uint32_t *)(TRACE_BASE + 0x0020))
#define TRACE_MEM_ADDR_UPDATE_REG ((uint32_t *)(TRACE_BASE + 0x000C))

#define IRAM_ATTR _SECTION_ATTR_IMPL(".iram1", __COUNTER__)

void sleep_us(int32_t us);
void reset_watchdogs();
void wdt_disable();

extern int ets_printf(const char *fmt, ...);
extern int uart_tx_one_char(uint8_t c);

static inline void nop()
{
    asm volatile("nop");
}

static inline void spin(volatile unsigned long count)
{
    while (count--)
        asm volatile("nop");
}

static inline uint64_t get_tick()
{
    *REG(TIMG0_TOUPDATE_REG) = 1;

    while (*REG(TIMG0_TOUPDATE_REG) != 0)
        nop();

    return *REG(TIMG0_TOLO_REG) + ((uint64_t)*REG(TIMG0_TOHI_REG) << 32);
}

static inline uint64_t uptime_us()
{
    return get_tick();
}

static inline void delay_us(unsigned long us)
{
    uint64_t until = uptime_us() + us; // Calculate timeout timestamp
    while (uptime_us() < until)
        nop(); // Wait until "until"
}

static inline void delay_ms(unsigned long ms)
{
    delay_us(ms * 1000);
}
