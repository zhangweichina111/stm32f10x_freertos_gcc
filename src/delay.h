#ifndef _DELAY_H_
#define _DELAY_H_

#include <stdint.h>

#define delay_ms(msec)	delay_us(msec * 1000)

void delay_init(void);
void delay_us(uint32_t usec);

#endif	/* _DELAY_H_ */
