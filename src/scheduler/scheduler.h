/************************************************************************/
/* Author: BRAVL                                                        */
/* Simple round robin scheduler implementation                          */
/************************************************************************/


#ifndef INCFILE1_H_
#define INCFILE1_H_

#include <stdint.h> /* *int*_t types include */
#include <stddef.h> /* NULL include */

#define TASK_LIST_SIZE 3

/* Scheduler task function pointer */
typedef void *(*scheduler_task_t) (void*);

/* Scheduler task list */
/* We know what tasks will be running, so no need to make this dynamic */
#warning "Make sure tasks are defined here and that the TASK_LIST_SIZE is correct"
extern const scheduler_task_t g_tasks[TASK_LIST_SIZE];

/* The task that is being executed */
static uint8_t g_current_task;

void scheduler_tick(void);

#endif /* INCFILE1_H_ */