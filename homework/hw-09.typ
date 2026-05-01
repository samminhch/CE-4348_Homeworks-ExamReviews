#import "@local/callouts:0.1.0": answer, important, question, task
#import "common.typ": code, problem

// Code listings
#import "@preview/codly:1.3.0": *
#show: codly-init
#import "@preview/codly-languages:0.1.10": *
#codly(languages: codly-languages)


#problem("6.1")[
  In Section 6.4, we mentioned that disabling interrupts frequently can affect
  the system's clock. Explain why this can occur and how such effects can be
  minimized
]

The system clock works on an interrupt @os-concepts[Sec. 1.4.3]. This means that
when disabling interrupts frequently, it can cause the system to repeatedly miss
the interrupts to update the system clock, therefore causing clock drifting.
This effect can be minimized if atomic hardware instructions (i.e. `CAS`) are
used to achieve mutual exclusion without the need to disable interrupts.

/ Mutual Exclusion: If process $P_i$ is executing in its critical section, then
  no other processes can be executing in their critical sections.
/ Atomic Operation: An atomic operation is an instruction that executes as a
  single, uninterruptible unit@os-concepts[Sec. 6.4.2]

#problem("6.4")[
  Show that, if the ```c wait()``` and ```c signal()``` semaphore operations
  are not executed atomically, then mutual exclusion may be violated
]

The ```c wait() ``` and ```c signal() ``` semaphore operations' implementation
can be seen in @listing:semaphore-operations. If those operations aren't atomic,
then, whilst a process is operating in its critical section, another process
could call ```c signal()``` and ```c wait()``` to enter its critical section at
the same time, which breaks the rule of mutual exclusivity

#figure(
  ```c
  wait(S) {
    while (S <= 0); // busy wait
    S--;
  }

  signal(S) { S++; }
  ```,
  caption: [Semaphore operations],
)<listing:semaphore-operations>

#pagebreak()
#problem("6.5")[
  Illustrate how a binary semaphore can be used to implement mutual exclusion
  among $n$ processes.
]

A binary semaphore can be used in the same way a mutex is used to ensure mutual
exclusion among $n$ processes. The first process in queue can execute
```c wait()```, and then enter its critical section. All other processes in
queue must wait for the first to send its ```c signal()``` operator before
entering their critical section.

#problem("6.12")[
  Some semaphore implementations provide a function ```c getValue() ```that
  returns the current value of a semaphore. This function may, for instance, be
  invoked prior to calling ```c wait()``` so that a process will only call
  ```c wait() ```if the value of the semaphore is greater than `0`, thereby
  preventing blocking while waiting for the semaphore. For example:
  ```c
  if (getValue(&sem) > 0)
    wait(&sem);
  ```

  Many developers argue against such a function and discourage its use. Describe
  a potential problem that could occur when using the function
  ```c getValue()``` in this scenario.
]

The issue with this that function is that it's not an atomic operation. The
second ```c getValue(&sem)``` is called, `sem` is already stale. This is seen in
the below example:

+ Process $A$ calls ```c getValue(&sem)```, which returns `1`.
+ A context switch occurs before Process $A$ can call ```c wait()```.
+ Process $B$ calls ```c wait(&sem)```, successfully decrements the semaphore to
  `0`, and enters its critical section
+ Process $A$ resumes and, believing the value is still `1` based on its
  previous check, calls ```c wait(&sem)```.
+ Since the semaphore is now `0`, Process A blocks anyways

#question(title: [= Programming Assignment])[
  Repeat programming assignment of assignment 8 part 2 but use
  ```c semaphore()``` instead of ```c thread_lock()```.
]
See @listing:semaphore-src for the source code and @listing:semaphore-outputs
for the output of the program ran three times

#counter(heading).step()
#bibliography("../references.yaml")

#pagebreak()
= Appendix
#[
  #show figure: set block(breakable: true)
  #set text(size: 0.70em)
  #figure(
    code("../projects/hw9/src/main.c", title-full: false),
    caption: [Source code for the programming assignment],
  )<listing:semaphore-src>
  #figure(
    code("../projects/hw9/output.txt", title-full: false),
    caption: [Output of running @listing:semaphore-src three times],
  )<listing:semaphore-outputs>
]
