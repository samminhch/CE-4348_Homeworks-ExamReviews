#import "@local/callouts:0.1.0": answer, important, question, task
#import "common.typ": problem

= Notes

Operating Systems are _interrupt driven_. There's two types of interrupts: *hardware interrupts* and *software interrupts*.

Hardware interrupts are usually internal faults and to mark that an operation has been completed. Software interrupts are usually system calls, such as to clone or exit a process, or to open, close, write, or read a file.

#important[Software interrupts are different for each system]

A primitive way of protection in an operating system is a dual-mode privilege set. There's two modes, user mode and system mode. System mode allows for running instructions that would interface with hardware (*privileged instructions*), and user mode programs won't be able to (unless they were granted permissions to do so)

#problem("1")[Give examples of privileged instructions in #strike[MIPS] RISC-V]
These instructions were found on https://docs.riscv.org/reference/isa/_attachments/riscv-privileged.pdf:
#answer(figure(
  table(
    columns: 3,
    align: (_, y) => { if y == 0 { center } else { left } },
    table.header(strong[Instruction], strong[Reason], strong[Instruction Type]),
    [`ECALL`],
    [Generate an exception],
    [3.3.1 | Environment Call and Breakpoint],

    [`EBREAK`],
    [A debugging breakpoint],
    [3.3.1 | Environment Call and Breakpoint],

    [`MRET/SRET`], [Return from trap], [3.3.2 | Trap-Return Instructions],
    [`WFI`], [A debugging breakpoint], [3.3.3 | Wait for Interrupt],
  ),
))

#problem("2")[Give examples of privileged instructions in ARM]

The following is found in https://developer.arm.com/documentation/ddi0406/latest:
#answer(figure(
  table(
    columns: 3,
    align: (_, y) => { if y == 0 { center } else { left } },
    table.header(strong[Instruction], strong[Reason], strong[Instruction Type]),
    `SVC`,
    [#strong[S]uper#strong[v]isor #strong[C]all, transfer lower privilege to higher privilege],
    [A8.8.229 | SVC (Previously SWI)],

    `ERET`, [Exception Return], [B9.3.3 | Exception Return],
  ),
))

#problem("2.1")[What is the purpose of system calls?]

#answer[According to section 2.3 of the textbook, system calls provide an interface, typically functions written in low-level languages to services that an operating system provides. ]

#problem("2.2")[
  What is the purpose of the command interpreter? Why is it usually separate from the kernel?
]

#answer[
  // Command interpreters are a set of system programs that receives commands and activates the appropriate program. For example, if it receives a copy instruction, it'll activate the copy service
  According to section 2.2.1 of the textbook, command interpreters (aka `bash`, `zsh`, `powershell`), is to retrieve and execute user-specified commands (e.g. `ls`, `cat`, `touch`, `rm` etc.) into system calls. This is typically separate from the kernel for protection --- if it was only in the kernel then it would always be running in privileged mode, when most use cases for the command-interpreter don't need all that power
]

#problem("2.4")[What is the purpose of system programs?]

#answer[
  System programs help the user call system commands. Some examples of these would be like `ls` to list files in a directory, or `rm` to remove a file
]

#pagebreak()
#problem("2.6")[
  List five services provided by an operating system, and explain how each creates convenience for users. In which cases would it be impossible for user-level programs to provide these services? Explain your answer.
]

#answer[
  According to section 2.1 of the textbook:
  + *Program execution:* How to start and finish programs. This eases the burden on the user from needing to know how exactly to load a program into system memory, and how to end their execution (normally or abnormally). A case where a user-level program would be unable to provide this service is a task manager that needs to send a `kill` signal to another processes or program.
  + *I/O Operations:* This service provides a mean for the user to interact with I/O devices, as reading from the network interface or writing to the file-system may be privileged actions that a normal user-level program are unable to perform.
  + *File-system manipulation:* This service provides a way for most programs to create, modify, or delete files and directories. However, user-level programs may not have access to this service when it comes to permissions management for certain files and directories in the file-system.
  + *Communications:* This service helps processes communicate between one another with a common interface, whether by writing to the same section of memory (shared memory), or by passing packets. It may be impossible for user-programs to provide these services if they do not have permission to write to that specific spot of shared memory, or if they are not allowed to send packets outside of their scope (host computer or directory).
  + *Error detection:* Helps detect overflow, illegal access to memory, illegal instructions, etc... User programs may not be able to access this service when needing to halt the system or terminate another process
]

#problem("2.7")[
  Why do some systems store the operating system in firmware, while others store it on disk?
]

#answer[
  Embedded systems store their operating system in the firmware because they're small controllers that *don't* have a disk in the first place
]

#problem("2.9")[
  The services and functions provided by an operating system can be divided into two main categories. Briefly describe the two categories, and discuss how they differ.
]

#answer[
  These are found in section 2.1 of the textbook:
  User-oriented services are those that "provides functions that are helpful to the user":
  - User interface
  - Program execution
  - I/O operations
  - File-system manipulation
  - Communications
  - Error Detection

  System-oriented services ensure "the efficient operation of the system itself":
  - Resource allocation
  - Logging
  - Protection and security
]

#problem("2.10")[
  Describe three general methods for passing parameters to the operating system
]

#answer[
  + Passing parameters via registers
  + Pushes information n the stack, and pops information out of the stack
  + Variables in system memory
]
