#import "@local/callouts:0.1.0": answer
#import "common.typ": problem

// Code Preview
#import "@preview/codly:1.3.0": *
#show: codly-init
#import "@preview/codly-languages:0.1.10": *
#codly(languages: codly-languages)

#problem("4.1")[
  Provide three programming examples in which multithreading provides better
  performance than a single-threaded solution
]

#answer[
  From @os-concepts[Ch. 4.1, p. 160]:
  - An application that creates photo thumbnails from a collection of images
    uses multithreading to generate thumbnails for each image
  - Web browser uses multithreading: one to display content, and one to retrieve
    data from the network
  - A word processor may use multiple threads to display content, responding to
    user keystrokes, and to perform spelling / grammar checking
]

#problem("4.2")[
  Using Amdahl's Law, calculate the speedup gain of an application that has a
  60% parallel component for...
  + Two processing cores
  + Four processing cores
]

The formula for speedup is shown below, where $P$ is the portion of the program
that can be parallelized ($0<=P<=1$), and $N$ is the number of processors
$
  S=1/((1-P)+P/N)
$

#answer[
  #set enum(numbering: "(A)")
  + $S=1/((1-0.6)+0.6/2)=1.429$
  + $S=1/((1-0.6)+0.6/2)=1.818$
]

#problem("4.5")[
  Describe the actions taken by a kernel to context switch between kernel-level
  threads
]

#answer[
  According to @os-concepts[Ch. ]
]

#problem("4.6")[
  What resources are used when a thread is created? How do they differ from
  those used when a process is created?
]

#answer[
  When a process is created, it'll need CPU time, memory, files, and I/O
  devices@os-concepts[Ch. 3.3, p. 117]. Threads, however, share memory and
  resources of the process that they belong to@os-concepts[Ch. 4.1.2, p. 162].
  The benefit of this is that it makes it easier for threads to context-switch
]

#problem("4.8")[
  Provide two programming examples in which multithreading *does not* provide
  better performance than a single-threaded solution.
]

#answer[
  Sequential programs are where multithreading does not benefit compared to a
  single-threaded solution.
  + A shell program---it needs to execute commands one at a time
  + A program that copies one file to another file
]

#problem("4.9")[
  Under what circumstances does a multithreaded solution using multiple kernel
  threads provide better performance than a single-threaded solution on a single
  processor system?
]

#answer[
  There's two scenarios in which multithreaded solutions provide better
  performance than a single-threaded solution:
  + When doing the same operation, such as generating thumbnails for a large
    photo directory.
  + When handling different tasks, in which a blocking task can be swapped out
    for another thread to continue running operations on.
]

#problem("4.10")[
  Which of the following components of program state are shared across threads
  in a multi-threaded process?

  + Register values
  + Heap memory
  + Global variables
  + Stack memory
]

#answer[
  Threads share *global variables*
]

#problem("4.13")[
  Is it possible to have concurrency but not parallelism? Explain.
]
#answer[
  It is possible to have concurrency without parallelism@os-concepts[Ch. 4.2,
    p.163], as a concurrent system supports multiple tasks by allowing all the
  tasks to make progress. This can be done on one thread by allotting time for
  one task to perform, then another, and so on, until the first task continues.
  This is in contrast to a parallel system which performs more than one task at
  once, requiring threads.
]

#problem("4.14")[
  Using Amdahl's Law, calculate the speed up gain for the following
  applications:
  #align(center, table(
    columns: 4,
    align: (_, y) => { if y < 1 { center } else { left } + horizon },
    table.header(
      [*Application \#*], [*%-Parallel*], [*Core Count A*], [*Core Count B*]
    ),
    [1], [40%], [8], [16],
    [2], [67%], [2], [4],
    [3], [90%], [4], [8],
  ))
]

#answer[
  + #grid(
      columns: 2,
      column-gutter: 2em,
      $"speedup" = 1/((1-0.40)+0.40/8) = 1.538$,
      $"speedup" = 1/((1-0.40)+0.40/16) = 1.6$,
    )
  + #grid(
      columns: 2,
      column-gutter: 2em,
      $"speedup" = 1/((1-0.67)+0.67/2) = 1.504$,
      $"speedup" = 1/((1-0.67)+0.67/4) = 2.010$,
    )
  + #grid(
      columns: 2,
      column-gutter: 2em,
      $"speedup" = 1/((1-0.90)+0.90/4) = 3.077$,
      $"speedup" = 1/((1-0.90)+0.90/8) = 4.706$,
    )
]

#problem("4.15")[
  Determine if the following problems exhibit task or data parallelism:
  - Using a separate thread to generate a thumbnail for each photo in a
    collection
  - Transposing a matrix in parallel
  - A networked application where one thread reads from the network and another
    writes to the network
  - The fork-join array summation application described in Section 4.5.2
  - The Grand Central Dispatch system
]

#figure(
  image("../assets/data-task-parallelism.png", width: 40%),
  caption: [Data and task parallelism@os-concepts[Ch. 4.2, p. 165]],
) <figure:data-task-parallelism>

#answer[
  #table(
    columns: 3,
    align: (x, _) => { if x == 0 { left } else { center } + horizon },
    table.header([*Problem*], [*Data Parallelism?*], [*Task Parallelism?*]),
    [Using a separate thread to generate a thumbnail for each photo in a
      collection],
    sym.checkmark,
    [],

    [Transposing a matrix in parallel], sym.checkmark, [],
    [A networked application where one thread reads from the network and another
      writes to the network],
    [],
    sym.checkmark,

    [The fork-join array summation application], sym.checkmark, [],

    [The Grand Central Dispatch system], [], sym.checkmark,
  )
]

#problem("4.16")[
  A system with two dual-core processors has four processors available for
  scheduling. A CPU-intensive application is running on this system. All input
  is performed at program start-up, when a single file must be opened.
  Similarly, all output is performed just before the program terminates, when
  the program results must be written to a single file. Between start-up and
  termination, the program is entirely CPU-bound. Your task is to improve the
  performance of this application by multithreading it. The application runs on
  a system that uses the one-to-one threading model (each user thread maps to a
  kernel thread).

  - How many threads will you create to perform the input and output? Explain.
  - How many threads will you create for the CPU-intensive portion of the
    application? Explain.
]

#answer[
  - I won't create another thread to perform input and output, as attempting to
    read a file with multiple threads won't make the read operation any quicker.
    Writing to a file with multiple threads leads to race conditions and
    potential file corruption
  - For the CPU-intensive portion of the program, I'll allocate 4 threads. This
    is because the system uses a one-to-one threading model, and since there are
    only 4 kernel threads, no more than 4 threads should be read in order to
    prevent context switching
]

#problem("4.17")[
  Consider @listing:4:17

  #figure(
    ```c
    #include <unistd.h>
    #include <pthread.h>
    int main() {
      pid_t pid = fork();
      if (pid == 0) { /* child process */
        fork();
        thread_create(/*...*/);
      }
      fork();
      return 0;
    }
    ```,
    caption: [Program for @problem:4.17],
  )<listing:4:17>

  How many unique...
  + processes are created?
  + threads are created?
]

#answer[
  From this program, *two unique threads* and *six unique processes* were
  created
]

#problem("4.19")[
  What would be the output from the program at labels `C` and `P`
  #codly(highlights: (
    (line: 15, start: 5, fill: green, tag: [C], label: <4.19-C>),
    (line: 19, start: 5, fill: green, tag: [P], label: <4.19-P>),
  ))
  #figure(
    caption: [Program for @problem:4.19],
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <pthread.h>
    #include <sys/wait.h>

    int value = 0;
    void *runner(void *param); /* the thread*/
    int main(int argc, char *argv[])
    {
      pid_t pid;
      pthread_t tid;
      pthread_attr_t attr;
      pid = fork();
      if (pid == 0) {/*child process*/
        pthread_attr_init(&attr);
        pthread_create(&tid,&attr,runner,NULL);
        pthread_join(tid, NULL);
        printf("CHILD: value = %d\n",value);
      }
      else if (pid > 0) { /* parent process*/
        wait (NULL);
        printf("PARENT: value = %d\n",value);
      }
    }
    void *runner(void *param) {
      value = 5;
      pthread_exit(0);
    }
    ```,
  )<listing:4.19>
]

#answer[
  The output at label `C` is...
  ```
  CHILD: value = 5
  ```

  And the output at label `P` is...
  ```
  PARENT: value = 0
  ```
]

#problem("4.20")[
  Consider a multicore system and a multithreaded program written using the
  many-to-many threading model. Let the number of user-level threads in the
  program be greater than the number or processing cores in the system. Discuss
  the performance implications of the following scenarios.

  + The number or kernel threads allocated to the program is less than the
    number of processing core.
  + The number of kernel threads allocated to the program is equal to the number
    of processing cores.
  + The number of kernel threads allocated to the program is greater than the
    number of processing cores but less than the number of user-level threads.
]

#answer[
  #set enum(numbering: "(A)")
  + Because there aren't enough kernel threads for the processing cores, some of
    the cores may sit in idle, which is a waste. If there's too many threads
    performing blocking calls, the application may freeze
  + All of the cores of the CPU are being used, which means that the system is
    performing optimally, so there isn't any need for context switching.
    However, if a thread has a blocking task, that core becomes idle.
  + This is the best case scenario, because if there is a blocking thread then
    the OS can swap it out for another available kernel thread. This is good in
    real-world scenarios where threads are running programs, interacting with
    the user, network, etc...
]

#problem("4.22")[
  Write a multithreaded program that calculates various statistical values for a
  list of numbers. This program will be passed a series of numbers on the
  command line and will then create three separate worker threads.

  One thread will determine the average of the numbers, the second will
  determine the maximum value, and the third will determine the minimum value.

  For example, suppose your program is passed the integers
  `{90, 81, 78, 95, 79, 72, 85}`. The program will report
  ```
  The average value is 82
  The minimum value is 72
  The maximum value is 95
  ```

  The variables representing the average, minimum, and maximum values will be
  stored globally. The worker threads will set these values, and the parent
  thread will output the values once the workers have exited. (We could
  obviously expand this program by creating additional threads that determine
  other statistical values, such as median and standard deviation.
]

#answer[
  See `mdn220004_ce4348-001_hw6_4-22.zip`. If that is not accessible, then here
  is the source code at the appendix
]

#bibliography("../references.yaml", title: "References")

= Appendix
#codly(header: [Listing for @problem:4.22 ])
```c
#include <pthread.h>
#include <stddef.h>
#include <stdio.h>

  double average;
  int minimum, maximum;

  typedef struct {
          const int *data;
          const size_t size;
  } vec_t;

  void *calc_avg(void *params);
  void *calc_min(void *params);
  void *calc_max(void *params);

  int main() {
      const int nums[] = {90, 81, 78, 95, 79, 72, 85};
      const vec_t data = {.data = nums, .size = sizeof(nums) / sizeof(nums[0])};
      // Create the threads
      pthread_t avg_thread, min_thread, max_thread;
      pthread_create(&avg_thread, NULL, calc_avg, (void *) &data);
      pthread_create(&min_thread, NULL, calc_min, (void *) &data);
      pthread_create(&max_thread, NULL, calc_max, (void *) &data);

      // Wait for threads to finish
      pthread_join(avg_thread, NULL);
      pthread_join(min_thread, NULL);
      pthread_join(max_thread, NULL);

      // Print out results!
      printf("The average value is %.2f\n", average);
      printf("The minimum value is %d\n", minimum);
      printf("The maximum value is %d\n", maximum);
      return 0;
  }

  void *calc_avg(void *params) {
      vec_t *vec = (vec_t *) params;

      float sum = 0;
      for (size_t i = 0; i < vec->size; i++) {
          sum += vec->data[i];
      }
      average = sum / vec->size;
      return NULL;
  }

  void *calc_min(void *params) {
      vec_t *vec = (vec_t *) params;

      if (vec->size == 0) {
          return NULL;
      }

      int min = vec->data[0];
      for (size_t i = 1; i < vec->size; i++) {
          if (vec->data[i] < min) {
              min = vec->data[i];
          }
      }
      minimum = min;
      return NULL;
  }

  void *calc_max(void *params) {
      vec_t *vec = (vec_t *) params;

      if (vec->size == 0) {
          return NULL;
      }

      int max = vec->data[0];
      for (size_t i = 1; i < vec->size; i++) {
          if (vec->data[i] > max) {
              max = vec->data[i];
          }
      }
      maximum = max;
      return NULL;
  }
```
