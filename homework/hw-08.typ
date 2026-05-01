#import "@local/callouts:0.1.0": answer, important, question, task
#import "common.typ": code, problem

// Code listings
#import "@preview/codly:1.3.0": *
#show: codly-init
#import "@preview/codly-languages:0.1.10": *
#codly(languages: codly-languages)

#problem("6.2")[
  What is the meaning of the term busy waiting? What other kinds of waiting are
  there in an operating system? Can busy waiting be avoided altogether? Explain
  your answer.
]

The term *busy waiting* (spinlock) is when processes must continuously request
to enter its critical section (looping the `acquire()`
function)@os-concepts[Sec. 6.5]. This can be avoided with the use of semaphores,
that temporarily puts the waiting process to sleep, and waking it up once the
lock becomes available @os-concepts[Sec. 6.6].

Other types of waits include *blocking* (process sleeping until the awaited
method finishes, or timeout), *deadlocks* (when one or more processes are
waiting for an event caused by only by one of the waiting processes), and
*timer-based waits* (i.e. `sleep()`)

#problem("6.3")[
  Explain why spinlocks are not appropriate for single-processor systems yet are
  often used in multiprocessor systems.
]

The reason spinlocks are more often used in multiprocessor systems as one thread
can "spin" on a core, while another performs its critical section on another
core @os-concepts[Sec. 6.5]. Single-processor systems don't have the cores to do
that, and it would just become a blocking task.

#problem("6.6")[
  Race conditions are possible in many computer systems. Consider a banking
  system that maintains an account balance with two functions: `deposit(amount)`
  and `withdraw(amount)`. These two functions are passed the amount that is to
  be deposited or withdrawn from the bank account balance. Assume that a husband
  and wife share a bank account. Concurrently, the husband calls the
  `withdraw()` function, and the wife calls `deposit()`. Describe how a race
  condition is possible and what might be done to prevent the race condition
  from occurring.
]

A race condition happens when either operation happens at nearly the same time
as one another. Here's a couple of scenarios I can think of:
- The husband calls `withdraw(X)` and the wife calls `withdraw(Y)` at the same
  time. The final balance could look like:
  $F_"new" = cases(F_"old"-X, F_"old"-Y)$, when in reality, it should look like
  this: $F_"new"=F_"old"-X-Y$.
- The husband / wife call `withdraw(X)` and `deposit(Y)` at the same time. The
  balance could look like this: $F_"new"=cases(F_"old"-X, F_"old"+Y)$, instead
  of $F_"new"=F_"old"+Y-X$
Basically, data corruption occurs. In order to prevent this from happening,
operations that update the bank balance need to be put in a mutex or binary
semaphore in order to ensure the operations are mutually exclusive.

#problem("6.7")[
  The pseudocode of @listing:6.7 illustrates the basic `push()` and `pop()`
  operations of an array-based stack. Assuming that this algorithm could be used
  in a concurrent environment, answer the following questions:

  + What data have a race condition?
  + How could the race condition be fixed?

  #figure(
    ```c
    push(item) {
      if (top < SIZE) {
        stack[top] = item;
        top++;
      } else { ERROR }
    }

    pop() {
      if (!is_empty()) {
        top--;
        return stack[top];
      } else { ERROR }
    }

    is_empty() { return top == 0; }
    ```,
    caption: [Array-based stack for @problem:6.7],
  )<listing:6.7>
]

The data that has a race condition are: `top` and `stack`. It can be fixed with
a binary semaphore:

```c
push(item) {
  wait(binary_sem);
  if (top < SIZE) {
    stack[top] = item;
    top++;
    signal(binary_sem);
  } else {
    signal(binary_sem);
    ERROR
  }
}

pop() {
  wait(binary_sem);
  if (!is_empty()) {
    top--;
    var val = stack[top];
    signal(binary_sem);
    return val;
  } else {
    signal(binary_sem);
    ERROR
  }
}

// assume that this is already synchronized?
is_empty() {
  return top == 0;
}
```

If I were to use `wait()` and `signal()` in `is_empty()`, it could lead to a
nested deadlock, since `is_empty()` would be waiting for a semaphore that was
never released in `pop()`. I think it would be best to either make `is_empty()`
a private function, or to remove it all-together and have a readonly variable
called `size()` that the programmer can use to check whether it is empty

#problem("6.8")[
  Race conditions are possible in many computer systems. Consider an online
  auction system where the current highest bid for each item must be maintained.
  A person who wishes to bid on an item calls the `bid(amount)` function, which
  compares the amount being bid to the current highest bid. If the amount
  exceeds the current highest bid, the highest bid is set to the new amount.
  This is illustrated below:

  #figure(
    ```c
    void bid(double amount) {
      if (amount > highestBid)
        highestBid = amount;
    }
    ```,
    caption: [`bid()` function for @problem:6.8],
  )

  Describe how a race condition is possible in this situation and what might be
  done to prevent the race condition from occurring
]

A race condition is possible in this situation `bid()` was called multiple times
where `amount > highestBid`, the `highestBid` could be changed multiple times at
nearly the same time, causing data corruption. It would be best to use a binary
semaphore or a mutex so that the function can be called atomically, preventing
race conditions.

#problem("6.11")[
  One approach for using `compare_and_swap()` for implementing a spin-lock is as
  follows:

  #figure(
    ```c
    void lock_spinlock(int *lock) {
      while (compare_and_swap(lock, 0, l) != 0)
        ; /* spin */
    }
    ```,
  )

  A suggested alternative approach is to use the "compare and compare-and-swap"
  idiom, which checks the status of the lock before invoking the
  `compare_and_swap()` operation. (The rationale behind this approach is to
  invoke `compare_and_swap()` only if the lock is currently available.) This
  strategy is shown below:

  #figure(
    ```c
    void lock_spinlock(int *lock) {
      while (true) {
        if (*lock == 0) {
          /* lock appears to be available */
          if (!compare_and_swap(lock, 0, 1))
            break;
        }
      }
    }
    ```,
  )

  Does this "compare and compare-and-swap" idiom work appropriately for
  implementing spinlocks? If so, explain. If not, illustrate how the integrity
  of the lock is compromised.
]

This approach is appropriate for implementing spinlocks, since it's a standard
spinlock with an extra read to try to avoid executing the CAS when the lock is
already taken. It does an initial non-atomic check to check if the lock is
_probably_ free, and if it isn't, then it doesn't need to waste resources with a
`CAS` call.

#line(length: 100%)
#pagebreak()
#question(title: [= Programming Assignment])[
  Assume two threads write simultaneously into a shared data file. First,
  without locking, and then by using a lock
]

#task[
  + Open a file (`datafile`) with two pointers, `fp1` and `fp2`.
  + Create two threads `f1` and `f2`:
    - Thread `f1` fills a 25#sym.times;25 array with all `1`s and writes them
      into `datafile`.
    - Thread `f2` fills a 25#sym.times;25 array with all `2`s and writes them
      into `datafile`.
  + Following thread exit, read the content of `datafile` into a 25#sym.times;25
    array and print the result
]

The outputs are fairly inconsistent with one another, and this is because a race
condition over the file pointer's `offset`. This is happening every time each
thread wants to write to `datafile`. The source code can be seen in
@listing:no-lock-src and the outputs can be seen in @listing:no-lock-outputs


#task[
  Repeat the previous part, but use `thread_lock` to protect the writing section
  of threads
]

There's no ```c thread_lock()``` function, but there's
```c pthread_mutex_lock(&mutex)``` and ```c pthread_mutex_unlock(&mutex)```. The
implementation can be seen in @listing:lock-src and the outputs can be seen in
@listing:lock-outputs

#pagebreak()
#counter(heading).step()
#bibliography("../references.yaml")
= Appendix
#{
  show figure: set block(breakable: true)
  [
    #figure(
      code("../projects/hw8/src/no_lock.c", title-full: false),
      caption: [Source code for the programming assignment],
    )<listing:no-lock-src>
    #pagebreak()
    #figure(
      code("../projects/hw8/no-lock_out.txt", title-full: false),
      caption: [Output of @listing:no-lock-src ran three times],
    )<listing:no-lock-outputs>
    #figure(
      code("../projects/hw8/src/lock.c", title-full: false),
      caption: [Source code for the programming assignment],
    )<listing:lock-src>
    #pagebreak()
    #figure(
      code("../projects/hw8/lock_out.txt", title-full: false),
      caption: [Output of @listing:no-lock-src ran three times],
    )<listing:lock-outputs>
  ]
}
