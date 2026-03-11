#import "@samminhch/callouts:0.1.0": question, answer, task, important
#let problem(number, body) = question(title: [= Problem #number], body)

#problem("3.1")[
  Using the program shown in @listing:3.1, explain what the output would be at @3.1:A

  #figure(
    [
    #codly(highlights:(
      (line: 15, start: 5,  fill: green, tag: "A", label: <3.1:A>),
    ))
    ```c
    #include <sys/types.h>
    #include <stdio.h>
    #include <unistd.h>
    int value = 5;
    int main()
    {
      pid_t pid;
      pid = fork();
      if (pid == 0) { /* child process */
        value += 15;
        return 0;
      }
      else if (pid > 0) {/*parent process*/
        wait (NULL);
        printf("PARENT: value = %d" ,value);
        return 0;
      }
    }
    ```
    ],
    caption: [What will be the output at @3.1:A?]
  )<listing:3.1>
]

#answer[
  The output at @3.1:A would be...
    #no-codly(
    ```
    PARENT: value = 5
    ```
  )
  because only the child process modifies `value`. The parent process does not modify `value` and instead just prints it out.
]

#pagebreak()
#problem("3.2")[
  Including the initial process, how many processes are created by @listing:3.2?
  #figure(
    ```c
    #include <stdio.h>
    #include <unistd.h>
    int main()
    {
      /* fork a child process */
      fork();
      /* fork another child process */
      fork();
      /* and fork another */
      fork();
      return O;
    }
    ```,
    caption: [How many processes are created?]
  )<listing:3.2>
]
#answer[
  8 processes are created. This is because in the first fork, the parent makes a child (two processes), and then they each make another child in the second `fork()`, making four children so far. Then the third `fork()` has each of those processes forking themselves to make eight children total:
  #no-codly(
    ```c
    int main()
    {
      fork(); /* Two processes, Parent (A) and Child (B);they both move to next line */
      fork(); /* Those two processes make copies of themselves, now 4 processes */
      fork(); /* And now each of those copied above make a copy of themselves (eight processes total!) */
      return O;
    }
    ```
  )
]

#problem("3.5")[
  When a process creates a new process using the `fork()` operation, which of the following states is shared between the parent process and the child process?

  #set enum(numbering: "a.")
  + Stack
  + Heap
  + Shared memory segments
]

#answer[
  *Shared memory segments* are shared between the parent and child process---the stack and heap are copied
]

#pagebreak()
#problem("3.9")[
  Construct a process tree similar to @figure:process-tree to obtain process information for the UNIX or Linux system.
  - *Basic Tree:* Use `pstree` alone to see the general hierarchy
  - *Include PIDs:* Use `pstree -p` to show *Process ID* next to each name
  - *Show Arguments:* Use `pstree -a` to see full command-line arguments used to start each process

  #figure(
    image("../assets/process-tree.png"),
    caption: [A tree of processes on a typical Linux system]
  )<figure:process-tree>
]

#answer[See the attached `mdn220004_hw4_pstree.zip`]

#problem("3.10")[
  Explain the role of the `systemd` process on UNIX and Linux systems in regard to process termination
]
#answer[
  The `systemd` process on UNIX is the "root parent process for all user processes" @os-concepts[p. 116], and
  as such it is capable of starting and stopping its child processes (all user processes)
]

#pagebreak()
#problem("3.11")[
  Including the initial process, how many processes are created by @listing:3.11?
  #figure(
    ```c
    #include <stdio.h>
    #include <unistd.h>
    int main()
    {
      int i;
      for (i = 0; i < 4; i++)
        fork();
      return 0;
    }
    ```,
    caption: [How many processes are created?]
  )<listing:3.11>
]
#answer[
  There are $2^4-1=15$ created processes from @listing:3.11. This is because each call to
  `fork()` creates a new process, and it doubles with each call
]

#pagebreak()
#problem("3.12")[
  Explain the circumstances under which @3.12:J will be reached

  #figure(
    [
      #codly(highlights:(
        (line: 15, start: 5,  fill: green, tag: "J", label: <3.12:J>),
      ))
      ```c
      #include <sys/types.h>
      #include <stdio.h>
      #include <unistd.h>
      int main()
      {
        pid_t pid;
        /* fork a child process */
        pid = fork();
        if (pid < 0) { /*error occurred*/
          fprintf (stderr, "Fork Failed");
          return 1;
        }
        else if (pid == 0) { /*child process*/
          execlp("/bin/ls", "ls", NULL);
          printf ("LINE J");
        }
        else {/*parent process*/
          /* parent will wait for the child to complete•*/
          wait(NULL);
          printf("Child Complete");
        }
        return 0;
      }
      ```
    ],
    caption: [When will @3.12:J be reached?]
  )<listing:3.12>
]

#answer[
  @listing:3.12:15 Would be reached when `fork()` returns 0, meaning that only the child process will reach that part of the code.
]

#pagebreak()
#problem("3.13")[
  Using the program in Figure 3.34, identify the values of `pid` at lines A, B, C, and D. Assume that the actual PIDs of the parent and child are 2600 and 2603, respectively.

  #figure(
    [
      ```c
      #include <sys/types.h>
      #include <stdio.h>
      #include <unistd.h>
      int main()
      {
        pid-t pid, pidl;
        /* fork a child process */
        pid = fork();
        if (pid < 0) {/*error occurred*/
          fprintf(stderr, "Fork Failed");
          return 1;
        }
        else if (pid == 0) {/*•child process•*/
          pid1 = getpid();
          printf("child: pid = %d",pid); /* A */
          printf("child: pidl = %d",pidl); /* B */
        }
        else {/*parent process*/
          pidl = getpid();
          printf("parent: pid = %d",pid); /* C */
          printf("parent: pidl = %d",pidl); /* D */
          wait(NULL);
        }
        return 0;
      }
      ```
    ],
    caption: [What are the PID values?]
  )<listing:3.13>
]

#answer[
  For the child (`A` and `B`), it'll print out:
  ```
  child: pid = 0
  child: pidl = 2603
  ```
  And for the parent process (`C` and `D`):
  ```
  parent: pid = 2603
  parent: pidl = 2600
  ```
]
#bibliography("../references.yaml", title: "References")
