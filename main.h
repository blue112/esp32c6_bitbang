#pragma once

#define LED_PIN 15
#define GPIO_MATRIX 0x60091000
#define GPIO_OUT_REG ((uint32_t *)(GPIO_MATRIX + 0x0004))
#define GPIO_ENABLE_REG ((uint32_t *)(GPIO_MATRIX + 0x0020))
#define GPIO_FUNCn_OUT_SEL_CFG_REG(n) ((uint32_t *)(GPIO_MATRIX + 0x0554 + 4 * n))

void loop();
int main(void);
