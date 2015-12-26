#include "led.h"
#include "usart.h"

#include "FreeRTOS.h"
#include "task.h"

#define LED_TASK_STACK_SIZE		(configMINIMAL_STACK_SIZE + 16)
#define LED_TASK_PRIORITY		(tskIDLE_PRIORITY + 1)

#define USART1_TASK_STACK_SIZE	(configMINIMAL_STACK_SIZE + 16)
#define USART1_TASK_PRIORITY	(tskIDLE_PRIORITY + 2)

static void led_task(void *args)
{
	TickType_t xPreviousWakeTime;
	xPreviousWakeTime = xTaskGetTickCount();
	for (;;) {
		led_on(LED0_PORT, LED0_PIN);
		led_off(LED1_PORT, LED1_PIN);
		vTaskDelayUntil(&xPreviousWakeTime, 1000 / portTICK_PERIOD_MS);
		led_off(LED0_PORT, LED0_PIN);
		led_on(LED1_PORT, LED1_PIN);
		vTaskDelayUntil(&xPreviousWakeTime, 1000 / portTICK_PERIOD_MS);
	}
}

static void usart1_task(void *args)
{
	for (;;) {
		usart_send_string(USART1, (const char *)args);
		vTaskDelay(1000 / portTICK_PERIOD_MS);
	}
}

int main()
{
	led_init();
	usart1_init(115200);

	xTaskCreate(led_task, "led_task", LED_TASK_STACK_SIZE, NULL, LED_TASK_PRIORITY, NULL);
	xTaskCreate(usart1_task, "usart1_task", USART1_TASK_STACK_SIZE, "Hello World\r\n", USART1_TASK_PRIORITY, NULL);

	vTaskStartScheduler();

	return 0;
}
