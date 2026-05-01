#import "@local/callouts:0.1.0": question, answer, task
#import "common.typ": problem

#problem("1.3")[
  What is the main difficulty that a programmer must overcome in writing an operating system for a real-time environment?
]

#answer[
  *Time constraints* are the main difficulty: programs that are written for a real-time environment are *time-sensitive*.
]

#problem("1.5")[
  How does the distinction between kernel mode and user mode function as a rudimentary form of protection (security)?
]

#answer[User-mode applications and programs shouldn't need full access to the system hardware, so the application typically asks the operating system for limited access or privileges to access that information] 

#problem("1.6")[
  Which of the following instructions should be privileged?
  #set enum(numbering: "a.")
  #grid(
    columns: 2, column-gutter: 2em,
    [
    + Set the value of the timer
    + Read the clock
    + Clear memory
    + Issue a trap instruction
    ],
    [
    #set enum(start: 5)
    + Turn off interrupts
    + Modify entries in device-status table
    + Switch from user to kernel mode
    + Access I/O device
    ]
  )
]

#answer[
  These instructions should be privileged:
  - Set value of a timer
  - Clear memory
  - Turn off interrupts
  - Modify entries in device-status table
  - Switch from user to kernel mode
  - Access I/O device
]

#problem("1.10")[
  Answer the below problems for caches:
]
#task[Give #strike[two] one reasons why caches are useful]
#answer[
The reason why caches are useful is because it makes memory access much faster
]

#task[What problems do they solve?]
#answer[
Without cache, the processor fetches and writes data to memory. However, the problem lies in that the processor is much faster than memory. The concept of caching is made to solve that issue
]

#task[What problems do they cause?]
#answer[
  - Multi-core CPU's have multiple caches that access the same main memory, which can lead to cache coherence problems (an example would be write conflicts if the write different data to the same address)
]

#task[If a cache can be made as large as the device for which it caching (for instance, a cache as large as a disk), why not make it that large and eliminate the device?]
#answer[
  Caches are static memory---it would be very expensive
]

#pagebreak()
#problem("1.14")[
  Answer the below problems about interrupts:
  What is the purpose of interrupts? How does an interrupt differ from a trap? Can traps be generated intentionally by a user program? If so, for what purpose?
]
#task[What is the purpose of interrupts?]
#answer[The purpose of an interrupt is to signal that an operation or request has been completed]

#task[How does an interrupt differ from a trap?]
#answer[Interrupts usually refers to hardware interrupts, while trap instructions are software interrupts]

#task[Can traps be generated intentionally by a user program? If so, for what purpose?]
#answer[
  Trap instructions can be generated intentionally by a user program, typically to ask some service from the operating system
]

#pagebreak()
#problem("1.16")[
  Direct memory access is used for high-speed I/O devices in order to avoid increasing the CPU’s execution load.
]
#task[
  How does the CPU interface with the device to coordinate the transfer?
]
#answer[
  #figure(
    image("../assets/dma-diagram.png", width: 40%),
    caption: [How the CPU interfaces with the DMA]
  )<figure:dma>
  The DMA device supervises the data coming from the network port directly into the memory module, freeing up the CPU to do other tasks. *The processor (CPU) gives information on how to supervise the incoming data*
]

#task[
  How does the CPU know when the memory operations are complete?
]
#answer[The DMA issues an interrupt after it finishes the operation]

#task[
  The CPU is allowed to execute other programs while the DMA controller is transferring data. Does this process interfere with the execution of the user programs? If so, describe what forms of interference are caused.
]
#answer[The process does not interfere with the execution of user programs. However, there can be access conflicts that arises when two processes are attempting to access the same memory. This can be solved by allocating time for each processes to access the data so that those conflicts do not arise.]

#problem("1.19")[
  Rank the following storage systems from the slowest to the fastest:

  #set enum(numbering: "a.")
  #grid(
    columns: 2, column-gutter: 2em,
    [
    + Hard-disk drives
    + Registers
    + Optical disk
    + Main memory
    ],
    [
    #set enum(start: 5)
    + Nonvolatile memory
    + Magnetic tapes
    + Cache
    ]
  )
]
#answer[
  From fastest (1) to slowest (7)
  #grid(
    columns: 4, column-gutter: 2em,
    [
  + Registers
  + Cache
    ],
    [
    #set enum(start: 3)
  + Main memory
  + Nonvolatile memory
    ],
    [
    #set enum(start: 5)
  + Hard-disk drives
  + Optical disk
    ],
    [
    #set enum(start: 7)
  + Magnetic tapes
    ]
  )
]

#problem("1.20")[
  Consider an SMP system similar to the one shown in @figure:symmetric-multiprocessing-architecture. Illustrate with an example how data residing in memory could in fact have a different value in each of the local caches
  #figure(
    image("../assets/symettric-multiprocessor.png", width: 40%),
    caption: [Symmetric multiprocessing architecture]
  )<figure:symmetric-multiprocessing-architecture>
]
#answer[
  Multi-core CPU's can be executing two separate programs, and the different programs would end up writing data to the caches.
]

#pagebreak()
#problem("1.22")[
  Describe a mechanism for enforcing memory protection in order to prevent a program from modifying the memory associated with other programs
]
#answer[
The memory-protection mechanism can be seen below in @figure:memory-protection. Programs are stored in memory, and usually contain their base address, and the limit or length of that the program takes up in the system's main memory. When a program wants to write to an address in main memory, the address is checked on whether it is *greater than the $"base"$ address and less than $"base"+"limit"$ address*. If any of those checks fail, then a hardware interrupt is signaled saying that the write instruction has failed. Otherwise, the address may be written to.

  #figure(
    image("../assets/memory-protection-mechanism.png"),
    caption: [Memory protection mechanism]
  )<figure:memory-protection>
]
