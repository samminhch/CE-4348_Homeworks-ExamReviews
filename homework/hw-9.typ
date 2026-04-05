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

#problem("6.4")[
  Show that, if the ```c wait() ``` and ```c signal() ``` semaphore operations
  are not executed atomically, then mutual exclusion may be violated
]

#problem("6.5")[
  Illustrate how a binary semaphore can be used to implement mutual exclusion
  among n processes.
]

#problem("6.12")[
  Some semaphore implementations provide a function ```c getValue() ```that
  returns the current value of a semaphore. This function may, for instance, be
  invoked prior to calling ```c wait()```so that a process will only call
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

#question(title: [= Programming Assignment])[
  Repeat programming assignment of assignment 8 part 2 but use
  ```c semaphore()``` instead of ```c thread_lock()```.
]
