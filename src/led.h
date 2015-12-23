#ifndef _LED_H_
#define _LED_H_

#include <stdint.h>
#include "stm32f10x_rcc.h"
#include "stm32f10x_gpio.h"

#define LED0_RCC	RCC_APB2Periph_GPIOD 
#define LED1_RCC	RCC_APB2Periph_GPIOG 

#define LED0_PORT	GPIOD
#define LED1_PORT	GPIOG

#define LED0_PIN	GPIO_Pin_13
#define LED1_PIN	GPIO_Pin_14

void led_init(void);
void led_on(GPIO_TypeDef* port, uint16_t pin);
void led_off(GPIO_TypeDef* port, uint16_t pin);

#endif	/* _LED_H_ */
