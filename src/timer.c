#include "timer.h"

#include "misc.h"
#include "stm32f10x_rcc.h"
#include "stm32f10x_tim.h"
#include "stm32f10x_gpio.h"

void tim2_init(void)
{
	TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
	NVIC_InitTypeDef NVIC_InitStructure;
	
	NVIC_InitStructure.NVIC_IRQChannel = TIM2_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
	
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM2, ENABLE);
	//----------------------------------------------------------------
	// T2M_Period = (TIM_Period + 1) * (TIM_Prescaler + 1) / Freq_ose
	// (8999 + 1) * (79 + 1) / 72,000,000 = 1 / 100 = 10ms
	//----------------------------------------------------------------
	TIM_TimeBaseStructure.TIM_Period = 8999;
	TIM_TimeBaseStructure.TIM_Prescaler = 79;
	TIM_TimeBaseStructure.TIM_ClockDivision = 0;
	TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Down;
	TIM_TimeBaseInit(TIM2, &TIM_TimeBaseStructure);
	
	TIM_ITConfig(TIM2, TIM_FLAG_Update, ENABLE);
	TIM_Cmd(TIM2, ENABLE);
}

void TIM2_IRQHandler(void)
{
	if (TIM_GetITStatus(TIM2, TIM_IT_Update) != RESET) {
		TIM_ClearFlag(TIM2, TIM_FLAG_Update);
	}
}

static TIM_OCInitTypeDef TIM3_OCInitStructure;
void pwm_init(void)
{
	TIM_TimeBaseInitTypeDef TIM_TimeBaseStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB | RCC_APB2Periph_AFIO, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM3, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;	/* PB0: TIM3_CH3 */
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	/* Time Base configuration */
	/* 45 * 100 * 16000 = 72,000,000; 66us = 16k */
	TIM_TimeBaseStructure.TIM_Prescaler = 17;
	TIM_TimeBaseStructure.TIM_CounterMode = TIM_CounterMode_Up;
	TIM_TimeBaseStructure.TIM_Period = 254;	/* 0~0xff: 0%~100% */
	TIM_TimeBaseStructure.TIM_ClockDivision = 0;
	TIM_TimeBaseStructure.TIM_RepetitionCounter = 0;
	
	TIM_TimeBaseInit(TIM3, &TIM_TimeBaseStructure);
	
	/* Configuration in PWM mode */
	TIM3_OCInitStructure.TIM_OCMode = TIM_OCMode_PWM1;
	TIM3_OCInitStructure.TIM_OutputState = TIM_OutputState_Enable;
	TIM3_OCInitStructure.TIM_OutputNState = TIM_OutputNState_Disable;
	
	TIM3_OCInitStructure.TIM_OCPolarity = TIM_OCPolarity_High;
	TIM3_OCInitStructure.TIM_OCIdleState = TIM_OCIdleState_Reset;
	
	TIM3_OCInitStructure.TIM_Pulse = PWM_MIN;
	TIM_OC3Init(TIM3, &TIM3_OCInitStructure);
	
	/* TIM1 counter enable */
	TIM_Cmd(TIM3, ENABLE);
	
	/* TIM3 Main Output Enable */
	TIM_CtrlPWMOutputs(TIM3, ENABLE);
}

void pwm_set(uint8_t pwm)
{
	TIM3_OCInitStructure.TIM_Pulse = pwm;
	TIM_OC3Init(TIM3, &TIM3_OCInitStructure);
}

uint8_t pwm_get(void)
{
	return TIM3_OCInitStructure.TIM_Pulse;
}
