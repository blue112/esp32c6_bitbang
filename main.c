#include "main.h"
#include "system.h"

#include <stdint.h>
#include <stdio.h>

volatile uint32_t *gpio_out_reg = GPIO_OUT_REG;
volatile uint32_t *gpio_enable_reg = GPIO_ENABLE_REG;

__attribute__((section(".trace_addr"))) uint32_t trace_memory[256];

void pin_set(uint8_t pin)
{
    uint32_t prev_value = *gpio_out_reg;
    uint32_t new_value = prev_value | ((uint32_t)1 << pin);
    *gpio_out_reg = new_value;
}

void pin_unset(uint8_t pin)
{
    uint32_t prev_value = *gpio_out_reg;
    uint32_t new_value = prev_value & ~((uint32_t)1 << pin);
    *gpio_out_reg = new_value;
}

void set_pin_output(uint8_t pin)
{
    // 128: Bit n of GPIO_OUT_REG and GPIO_ENABLE_REG are selected as the output value and output enable.
    volatile uint32_t *gpio_outsel_cfg = GPIO_FUNCn_OUT_SEL_CFG_REG(pin);
    *gpio_outsel_cfg = 128;

    uint32_t prev_value = *gpio_enable_reg;
    uint32_t new_value = prev_value | ((uint32_t)1 << pin);
    *gpio_enable_reg = new_value;
}

int main(void)
{
    set_pin_output(LED_PIN);
    pin_set(LED_PIN);

    int i = 0;

    while (1)
    {
        loop(i++);
    }
}

void loop(int i)
{
    delay_ms(500);
    pin_unset(LED_PIN);
    delay_ms(500);
    pin_set(LED_PIN);
    printf("Tick %d: %lld\n", i, uptime_us() / 1000);
}
