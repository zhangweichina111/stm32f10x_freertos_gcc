#ifndef _TIMER_H_
#define _TIMER_H_

#include <stdint.h>

#define PWM_MAX		0xFF
#define PWM_MIN		0x00

void tim2_init(void);
void pwm_init(void);
void pwm_set(uint8_t pwm);
uint8_t pwm_get(void);

#endif	/* _TIMER_H_ */
