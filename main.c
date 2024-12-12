#include "main.h"
#include "system.h"

#include <stdint.h>
#include <string.h>
#include <stdio.h>

volatile uint32_t *gpio_out_reg = GPIO_OUT_REG;
volatile uint32_t *gpio_enable_reg = GPIO_ENABLE_REG;

volatile uint32_t *trace_mem_start_addr_reg = TRACE_MEM_START_ADDR_REG;
volatile uint32_t *trace_mem_end_addr_reg = TRACE_MEM_END_ADDR_REG;
volatile uint32_t *trace_trigger_reg = TRACE_TRIGGER_REG;
volatile uint32_t *trace_mem_addr_update_reg = TRACE_MEM_ADDR_UPDATE_REG;

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

    while (1)
    {
        loop();
    }
}

void loop()
{
    spin(5000000);
    pin_unset(LED_PIN);
    spin(5000000);
    pin_set(LED_PIN);
}