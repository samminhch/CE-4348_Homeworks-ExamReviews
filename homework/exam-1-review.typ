#import "@local/callouts:0.1.0": answer, note, question
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node, shapes
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.8": *
#show: codly-init.with()
#codly(languages: codly-languages, reference-sep: ":")
#let problem(number, body) = [
  #figure(
    kind: "Problem",
    supplement: [Problem],
    numbering: n => number,
    [
      #set align(left)
      #set enum(numbering: "(A)")
      #question(title: [= Problem #number], body)
    ],
  )
  #label("problem:" + str(number))
]


#problem("3.1")[
  Explain what the output will be at @3.1:A
  #codly(highlights: (
    (line: 16, start: 5, fill: green, tag: [A], label: <3.1:A>),
  ))
  #figure(
    ```c
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <unistd.h>
    #include <stdio.h>
    int value = 5;

    int main()
    {
      pid_t pid;
      pid = fork();
      if (pid == 0) { /* child process */
        value += 15;
        return 0;
      } else if (pid > 0) { /* parent process */
        wait(NULL);
        printf("PARENT: value = %d", value);
        return 0;
      }
    }
    ```,
    caption: [Code snippet for @problem:3.1],
  )<listing:3.1>
]

Since the `fork()` was called before `value` was changed, the parent process
jumps immediately to @3.1:A, leading the output to be...
#answer[
  #no-codly(```
  PARENT: value = 5
  ```)
]

#problem("3.30")[
  Explain what the output will be at @3.30:C and @3.30:P
  #codly(highlights: (
    (line: 16, start: 5, fill: blue, tag: [C], label: <3.30:C>),
    (line: 19, start: 5, fill: purple, tag: [P], label: <3.30:P>),
  ))
  #figure(
    ```c
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <pthread.h>
    #include <unistd.h>
    #include <stdio.h>
    int value = 0;
    void *runner(void *p) { value = 5; return NULL; }

    int main()
    {
      pid_t pid = fork();
      if (pid == 0) {
        pthread_t tid; pthread_attr_t a;
        pthread_attr_init(&a);
        pthread_create(&tid, &a, runner, NULL);
        printf("CHILD: value=%d\n", value);
      } else {
        wait(NULL);
        printf("PARENT: value=%d\n", value)
      }
    }
    ```,
    caption: [Code snippet for @problem:3.30],
  )<listing:3.30>
]

In @listing:3.30:11, `fork()` is called and a child process is made. That child
process creates a thread which updates `value` to be `5`. However, the parent
process does not see that action, so it prints that `value=0`

#answer[
  The output at @3.30:C will be either...
  #no-codly(```
  CHILD: value=5
  CHILD: value=0
  ```)
  This is because the thread created isn't being waited until it joins back into
  the main thread, so `printf` may occur before the child thread finishes its
  execution and joins the main thread

  The output at @3.30:P will be

  #no-codly(```
  PARENT: value=0
  ```)
]

#problem("3.x")[
  Explain what the output would be at @3.x:GC, @3.x:C, and @3.x:P
  #codly(highlights: (
    (line: 14, start: 7, fill: green, tag: [GC], label: <3.x:GC>),
    (line: 17, start: 7, fill: blue, tag: [C], label: <3.x:C>),
    (line: 21, start: 5, fill: purple, tag: [P], label: <3.x:P>),
  ))
  #figure(
    ```c
    int value = 0;
    void *runner(void *p) { value = 9; return NULL; }

    int main() {
      pid_t pid = fork();
      if (pid == 0) {
        pthread_t tid; pthread_attr_t a;
        pthread_attr_init(&a);
        pthread_create(&tid, &a, runner, NULL);
        pthread_join(tid, NULL);

        pid_t pid2 = fork();
        if (pid2 == 0) {
          printf("GRANDCHILD: value=%d\n", value);
        } else {
          wait(NULL);
          printf("CHILD: value=%d\n", value);
        }
      } else {
        wait(NULL);
        printf("PARENT: value=%d\n", value);
      }
    }
    ```,
    caption: [Code snippet for @problem:3.x],
  )<listing:3.x>
]
Because the child process created a thread that modified `value` before the
grandchild process was created, the child and grandchild process will have the
same number for `value`

#answer[
  The output at @3.x:GC will be...
  #no-codly(```
  GRANDCHILD: value=9
  ```)
  The output at @3.x:C will be...
  #no-codly(```
  CHILD: value=9
  ```)
  The output at @3.x:P will be...
  #no-codly(```
  PARENT: value=0
  ```)
]

#problem("4.16")[
  A system with two dual-core processors has four processors available for
  scheduling. A CPU-intensive application is running on this system. All input
  is performed at program start-up, when a single file must be opened.
  Similarly, all output is performed just before the program terminates, when
  the program results must be written to a single file. Between start-up and
  termination, the program is entirely CPU-bound. Your task is to improve the
  performance of this application by multi-threading it. The application runs on
  a system that uses the one-to-one threading model (each user thread maps to a
  kernel thread).

  - How many threads will you create to perform the input and output? Explain.
  - How many threads will you create for the CPU-intensive portion of the
    application? Explain.
]

#answer[
  - Since reading and writing files are blocking tasks, there will be a total of
    two threads created, *one for reading in the file*, and *one for writing to
    a file*
  - For the CPU-intensive portion of the application, *four threads are to be
    created*.
    - \<4 threads mean that there are idle threads, meaning that it's being
      underutilized
    - \>4 threads mean that context-switching will have to occur to switch out a
      kernel thread for a user thread
]

#problem("4.16.b")[
  Same system, but input is split across 4 independent files at startup; output
  is one file at end.
]
#answer[
  - *Four threads* created for input files, *one thread* for the output file
  - *Four threads* created for the CPU-intensive task
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
  *Global variables* and *heap memory* are shared across threads
]

#pagebreak()
#problem("4.1")[
  Provide three programming examples in which multi-threading provides better
  performance than a single-threaded solution. Clearly state whether in single
  or multiple core.
]

#answer[
  #table(
    columns: 3,
    table.header([*Example*], [*Single Core*], [*Multi-core*]),
    [Spreadsheet], sym.checkmark, sym.checkmark,
    [Server], sym.checkmark, sym.checkmark,
    [Matrix multiplication], [], sym.checkmark,
    [Producer-consumer], [], sym.checkmark,
  )
]

#problem("3.12")[
  Explain the circumstances in which @3.12:J will be reached

  #codly(highlights: (
    (line: 14, start: 4, tag: [J], fill: green, label: <3.12:J>),
  ))
  #figure(
    ```c
    #include <sys/types.h>
    #include <stdio.h>
    #include <unistd.h>
    int main()
    {
     Pid_t pid;
     /* fork a child process */
     pid = fork();
     if (pid < 0) { /*error occurred*/
       fprintf (stderr, "Fork Failed");
       return 1;
     } else if (pid == 0) { /*child process*/
       execlp("/bin/ls" ,"ls" ,NULL);
       printf ("LINE J");
     } else {/*parent process */
       /* parent will wait for the child to complete•*/
       wait(NULL);
       printf("Child Complete");
     }
     return 0
    }
    ```,
    caption: [Code snippet for @problem:3.12],
  )<listing:3.10>
]
#answer[
  @3.12:J will be reached whenever the child process runs `/bin/ls` and that
  program fails
]

#problem("3.y")[
  How many times will @3.y:J print?
  #codly(
    highlights: (
      (line: 5, start: 5, color: green, tag: [J], label: <3.y:J>),
    ),
  )
  #figure(
    ```c
    for (int i=0; i<2; i++) {
      pid_t p = fork();
      if (p == 0 && i == 1) {
        execlp("/bin/date", "date", NULL);
        printf("LINE J\n");
      }
    }
    while (wait(NULL) > 0) { }
    printf("END\n");
    ```,
    caption: [Code snippet for @problem:3.12],
  )<listing:3.y>
]
#answer[
  @3.y:J can print a maximum of 1 times, if `/bin/date` fails to run. Otherwise,
  @3.y:J won't be printed at all.
]

#pagebreak()
#problem("1.6")[
  Which of the following operations should be privileged?

  + Set value of a timer
  + Read the clock
  + Clear memory
  + Issue a trap instruction
  + Turn off interrupts
  + Modify entries in device-status table
  + Switch from user to kernel mode
  + Access I/O device
]
#answer[
  #table(
    columns: 2,
    table.header([*Operation*], [*Privileged?*]),
    [Set value of a timer], sym.checkmark,
    [Read the clock], [],
    [Clear memory], sym.checkmark,
    [Issue a trap instruction], [],
    [Turn off interrupts], sym.checkmark,
    [Modify entries in device-status table], sym.checkmark,
    [Switch from user to kernel mode], [],
    [Access I/O device], sym.checkmark,
  )
]

#question[
  What is the purpose of memory hierarchy?
]
#answer[
  The memory hierarchy will look like this:
  + cache
  + ram
  + disk

  - As you're going down the list, the capacity becomes larger and it's cheaper
  - As you're going up the list, the speed increases
]

#pagebreak()
#question[
  What are some examples of...

  + System calls
  + Library functions
  + System programs
  + Shells
]

#answer(table(
  columns: 2,
  align: (_, y) => { if y == 0 { center } else { left } + horizon },
  table.header([], [*Examples*]),
  [System Calls], [`fork`, `exit`, `kill`],
  [Library Functions], [`gets`, `puts`, `printf`, `malloc`, `fopen`],
  [System Programs], [`ls`, `cp`, `mv`, `rm`],
  [Shells], [`bash`, `zsh`, `fish`],
))

#question[
  What are the events that cause state transitions?

  #diagram(
    node-stroke: .1em,
    node-fill: blue.lighten(80%),

    node((0, 0), `new`),
    node((1, 1), `ready`),
    node((1.5, 2), `waiting`),
    node((2, 1), `running`),
    node((3, 0), `terminated`),

    edge((0, 0), (1, 1), `[1]`, "->", bend: 45deg),
    edge((1, 1), (2, 1), `[2]`, "->", bend: 45deg),
    edge((1.5, 2), (1, 1), `[3]`, "->", bend: 60deg),
    edge((2, 1), (1, 1), `[4]`, "->", bend: 45deg),
    edge((2, 1), (1.5, 2), `[5]`, "->", bend: 60deg),
    edge((2, 1), (3, 0), `[6]`, "->", bend: 30deg),
  )
]

#answer[
  #enum(numbering: "[1]")
  + Process creation
  + CPU scheduler selects process and assigns it to CPU
  + Blocking task completed (ex: I/O, `sleep`)
  + Time slice expires (preemption, in concurrency); higher priority process
    arrives
  + Blocking task (ex: I/O, `sleep`, `wait`)
  + Process finishes execution (via. `exit()`), or is killed
]

#note(diagram(
  node-stroke: .1em,
  node-fill: blue.lighten(80%),

  node((0, 0), [User Program]),
  edge([uses], "->"),
  node((1, 0), [API/Function Calls]),
  edge([may\ invoke], "->"),
  node((2, 0), [System Calls]),
  edge("->"),
  node((3, 0), [OS Kernel]),
))
