/************************************************************************/
/* Author: BRAVL                                                        */
/* Simple round robin scheduler implementation                          */
/************************************************************************/

#include "scheduler.h"

void scheduler_tick(void)
{
	uint8_t task_iter = 0;
	for (task_iter = 0; task_iter < TASK_LIST_SIZE; task_iter++)
	{
		if (g_tasks[task_iter]) 
		{
			g_current_task = task_iter;
			g_tasks[task_iter](NULL);
		}		
	}
	return;
}