#include "delay.h"
#include "stm32f10x_rcc.h"

#define DWT_CR				(*(volatile u32 *)0xE0001000)
#define DWT_CYCCNT			(*(volatile u32 *)0xE0001004)
#define DEM_CR				(*(volatile u32 *)0xE000EDFC)
#define DEM_CR_TRCENA		(1 << 24)
#define DWT_CR_CYCCNTENA	(1 <<  0)

static uint32_t cpu_freq;

void delay_init(void)
{
	RCC_ClocksTypeDef RCC_ClockFreq;
	RCC_GetClocksFreq(&RCC_ClockFreq);
	cpu_freq = RCC_ClockFreq.SYSCLK_Frequency;

    DEM_CR |= DEM_CR_TRCENA;
	DWT_CYCCNT = 0;
    DWT_CR |= DWT_CR_CYCCNTENA;
}

void delay_us(uint32_t usec)
{
	uint32_t startts, endts, ts;
	startts = DWT_CYCCNT;
	ts = usec * (cpu_freq / (1000 * 1000));
	endts = startts + ts;
	if (endts > startts) {
		while (DWT_CYCCNT < endts);
	} else {
		while (DWT_CYCCNT > endts);
		while (DWT_CYCCNT < endts);
	}
}
