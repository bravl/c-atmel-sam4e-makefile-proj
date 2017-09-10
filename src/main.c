#include "asf.h"
#include <stdint.h> /* *int*_t types include */
#include <stddef.h> /* NULL include */

#include "scheduler/scheduler.h"

void *uart_task(void *task_data);
void *second_uart_task(void *task_data);
void *simple_delay_task(void *task_data);

const scheduler_task_t g_tasks[TASK_LIST_SIZE] = {
	uart_task,
	second_uart_task,
	simple_delay_task
};

void *uart_task(void *task_data)
{
	puts("Test Makefile\r");
	return 0;
}

void *second_uart_task(void *task_data)
{
	puts("Another task\r");
	return 0;
}

void *simple_delay_task(void *task_data)
{
	delay_s(1);
	return 0;
}

static void configure_uart(void)
{
	const sam_usart_opt_t usart_console_settings = {
		115200,
		US_MR_CHRL_8_BIT,
		US_MR_PAR_NO,
		US_MR_NBSTOP_1_BIT,
		US_MR_CHMODE_NORMAL,
		/* This field is only used in IrDA mode. */
		0
	};
	
	sysclk_enable_peripheral_clock(CONSOLE_UART_ID);
	stdio_serial_init(CONSOLE_UART,&usart_console_settings);
}

int main (void)
{
	board_init();
	sysclk_init();
	configure_uart();
	
	for(;;) {
		scheduler_tick();
	}
	
	return 0;
}
