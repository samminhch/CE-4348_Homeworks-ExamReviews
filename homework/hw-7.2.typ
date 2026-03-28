#import "@local/callouts:0.1.0": answer, important, task
#import "common.typ": problem
#import "@preview/timeliney:0.4.0"

#problem("5.5")[
  @table:5.5 is being scheduled using a preemptive, round robin scheduling
  algorithm ($Q=10$). The system also has an idle task, $P_"idle"$ (priority=0),
  which consumes on CPU resources and is scheduled to run whenever no other
  processes are available to run. If a process is preempted by a higher-priority
  process, the preempted process is placed at the queue's end

  #figure(
    table(
      columns: 4,
      table.header([*Process*], [*Priority*], [*Burst*], [*Arrival*]),
      $P_1$, $40$, $20$, $0$,
      $P_2$, $30$, $25$, $25$,
      $P_3$, $30$, $25$, $30$,
      $P_4$, $35$, $15$, $60$,
      $P_5$, $5$, $10$, $100$,
      $P_6$, $10$, $10$, $105$,
    ),
    caption: [Process list for @problem:5.5],
  )<table:5.5>

  + Show the scheduling order of the processes using a Gantt chart.
  + What is the turnaround time for each process?
  + What is the waiting time for each process?
  + What is the CPU utilization rate?
]

#figure(
  timeliney.timeline(show-grid: true, {
    import timeliney: *
    headerline(group(..range(12).map(it => str((it + 1) * 10))))
    taskgroup({
      task($P_1$, (0, 1), (1, 2)) // B=20; P=40
      task($P_2$, (2.5, 3.5), (4.5, 5.5), (6.5, 7)) // B=25; P=30
      task(
        $P_3$,
        (
          from: 3,
          to: 3.5,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (3.5, 4.5),
        (5.5, 6.5),
        (8, 8.5),
      ) // B=20; P=30
      task(
        $P_4$,
        (
          from: 6,
          to: 7,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (7, 8),
        (8.5, 9),
      ) // B=15; P=35
      task($P_5$, (10, 11)) // B=10; P=5
      task(
        $P_6$,
        (
          from: 10.5,
          to: 11,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (11, 12),
      ) // B=10; P=10
      task($P_"idle"$, (2, 2.5), (9, 10)) // B=20; P=40
    })
    milestone(at: 0, style: (stroke: (dash: "dashed")), $P_1$)
    milestone(at: 1, style: (stroke: (dash: "dashed")), $P_1$)
    milestone(at: 2.5, style: (stroke: (dash: "dashed")), $P_2$)
    milestone(at: 3.5, style: (stroke: (dash: "dashed")), $P_3\ P_2$)
    milestone(at: 4.5, style: (stroke: (dash: "dashed")), $P_2\ P_3$)
    milestone(at: 5.5, style: (stroke: (dash: "dashed")), $P_3\ P_2$)
    milestone(at: 6, style: (stroke: (dash: "dashed")), $P_3\ P_2\ P_4$)
    milestone(at: 6.5, style: (stroke: (dash: "dashed")), $P_2\ P_4\ P_3$)
    milestone(at: 7, style: (stroke: (dash: "dashed")), $P_4\ P_3$)
    milestone(at: 8, style: (stroke: (dash: "dashed")), $P_3\ P_4$)
    milestone(at: 8.5, style: (stroke: (dash: "dashed")), $P_4$)
    milestone(at: 10, style: (stroke: (dash: "dashed")), $P_5$)
    milestone(at: 10.5, style: (stroke: (dash: "dashed")), $P_5\ P_6$)
    milestone(at: 11, style: (stroke: (dash: "dashed")), $P_6$)
  }),
  caption: [The light-blue line represents the time when a process arrives until
    its first slice],
)

#figure(
  table(
    columns: 4,
    table.header([*Process*], [*$t_A$*], [*$t_C$*], [*$t_"TA"$*]),
    $P_1$, $0$, $20$, $20$,
    $P_2$, $25$, $70$, $45$,
    $P_3$, $30$, $85$, $55$,
    $P_4$, $60$, $90$, $30$,
    $P_5$, $100$, $110$, $10$,
    $P_6$, $105$, $120$, $15$,
  ),
  caption: [Turnaround times (ms) of each process for each scheduling
    algorithm],
)

Recall from the previous homework that $t_W=t_A-t_B$, where $t_B$ is the burst
time. From this we can calculate the waiting time for each process:

#figure(
  table(
    columns: 4,
    table.header([*Process*], [*$t_"TA"$*], [*$t_B$*], [*$t_W$*]),
    $P_1$, $20$, $20$, $0$,
    $P_2$, $45$, $25$, $20$,
    $P_3$, $55$, $25$, $30$,
    $P_4$, $30$, $15$, $15$,
    $P_5$, $10$, $10$, $0$,
    $P_6$, $15$, $10$, $5$,
  ),
  caption: [Waiting times (ms) of each process for each scheduling algorithm],
)

The CPU utilization rate ($U$) is the ratio of the sum of the burst rates over
the total elapsed time it took to complete all processes:

$
  U & =(sum t_B)/(T) \
    & = (20 + 25 + 25 + 15 + 10 + 10)/120 \
  U & = 0.875 = 87.5%
$

#pagebreak()
#problem("5.8")[
  Suppose that a CPU scheduling algorithm favors those processes that have used
  the least processor time in the recent past. Why will this algorithm favor
  I/O-bound programs and yet not permanently starve CPU-bound programs?
]

I/O-bound programs typically have short CPU burst times, as they spend the
majority of the time waiting for I/O devices such as disks (which are much
slower than processes) @os-concepts[Sec. 3.2.1]. This means that they
consistently become "processes thta have used the least processor time in the
recent past", giving them a much higher priority.

The nature of I/O processes also means that it won't permanently starve
CPU-bound programs. While the I/O programs are waiting for their devices, the
scehduling algorithm can schedule the CPU-bound processes until the I/O-bound
program is ready again.



#problem("5.10")[
  The traditional UNIX scheduler enforces an inverse relationship between
  priority numbers and priorities: the higher the number, the lower the
  priority. The scheduler recalculates process priorities once per second using
  the following function:
  $
    "priority"=1/2("recent CPU usage") + "base"
  $
  Where $"base"=60$ and recent CPU usage refers to a value indicating how often
  a process has used the CPU since priorities were last recalculated. Assume
  that the recent CPU usage for process $P_1=40$, $P_2=18$, and $P_3=10$.

  + What will the new priorities for these three processes when priorities are
    recalculated?
  + Based on this information, does the traditional Unix scheduler raise or
    lower the relative priority of a CPU-bound process?
]

#figure(
  table(
    columns: 2,
    table.header([*Process*], [*Priority*]),
    $P_1$, $1/2(40)+60=80$,
    $P_2$, $1/2(18)+60=69$,
    $P_3$, $1/2(10)+60=65$,
  ),
)

Based on this information, the traditional Unix scheduler would lower the
relative priority of a CPU-bound process. This is because the CPU usage has an
inverse relationship with priority---the more the CPU is used (i.e. CPU-buond
tasks), the lower their priority.

#pagebreak()
#problem("5.11")[
  Of these two types of programs, *I/O-bound* and *CPU-bound*, which is likelier
  to have voluntary context switches, and which is likelier to have
  non-voluntary context switches? Explain your answer.
]

A context switch means that the CPU saves the context of a current process
running on its core, and replaces it with a new process on the same
core@os-concepts[Sec. 3.2.3]. This effectively means that the program no longer
has control of the CPU.

I/O-bound programs are more likely to have voluntary context switches because
when they need to wait for their devices to complete a task.

CPU-bound programs, on the other hand, are more likely to have non-voluntary
conetxt switches, as their burst times are much longer than I/O-bound programs.
A typical RR scheduler would have to put the process back into the ready queue
as the burst time is usually much longer than the RR quantum.

#problem("5.12")[
  Discuss how the following pairs of scheduling criteria conflict in certain
  settings:

  + CPU utilization rate and response time
  + Average turnaround time and maximum waiting time
  + I/O device utilization and CPU utilization
]

A high respones time requries very frequent context switches (i.e. a low quantum
rate). However, too low of a quantum rate affects CPU utilization rate, the more
context context is performed, the less the CPU is used, as context switching is
"pure overhead" where the system "does no useful work"@os-concepts[Sec.
  3.2.3]@os-concepts[Sec. 5.3.3]

SJF scheduling algorithms work to minimize the average waiting time, which in
turn, minimizes the average turnaround time. The pitfall of this algorithm,
however, is that it starves processes with the highest-burst time, which
increases the maximum waiting time.

If I/O-bound programs are favored more than CPU-bound programs, that will result
in more context switches, leading to lower CPU utilization. However, if
CPU-bound programs are more favored in order to maximize the CPU-utilization
rate, it will lead to I/O devices sitting in idle and lowering the I/O device
utilization rate.

#problem("5.14")[
  Most scheduling algorithms maintain a run queue, which lists processes
  eligible to run on a processor. On multicore systems, there are two general
  options: *(1)* each processing core has its own run queue, or *(2)* a single
  run queue is shared by all processing cores. What are the advantages and
  disadvantages of each of these approaches?
]

#problem("5.15")[
  Consider the exponential average formula used to predict the length of the
  next CPU burst. What are the implications of assigning the following values to
  the parameters used by the algorithm?

  + $alpha=0, tau_0=100"ms"$
  + $alpha=0.99, tau_0=10"ms"$
]

The exponential average formula is defined below:
$
  tau_(n+1)=alpha t_n+(1-alpha)tau_n
$
Where $t_n$ is the $n"th"$ CPU burst, $tau_(n+1)$ is the next predicted CPU
burst, and $alpha$ controls the relative weight of recent / past
history@os-concepts[p. 208]

Plugging the numbers in makes this:
$
  tau_(n+1)=cases(
    tau_n & "where" alpha=0"," tau_0=100"ms",
    0.99t_n + 0.01tau_n & "where" alpha=0.99"," tau_0=10"ms"
  )
$

For the first case, the burst times will always be a constant $100"ms"$, but for
the second case, the burst time will continue to increase exponentially

#pagebreak()
#problem("5.18")[
  The following processes are being scheduled using a preemptive,
  priority-based, round-robin scheduling algorithm.
  #figure(
    table(
      columns: 4,
      table.header([*Process*], [*Priority*], [*Burst*], [*Arrival*]),
      $P_1$, $8$, $15$, $0$,
      $P_2$, $3$, $20$, $0$,
      $P_3$, $4$, $20$, $20$,
      $P_4$, $4$, $20$, $25$,
      $P_5$, $5$, $5$, $45$,
      $P_6$, $5$, $15$, $55$,
    ),
  )
  Each process is assigned a numerical priority, with a higher number indicating
  a higher relative priority. The scheduler will execute the highest priority
  process. For processes with the same priority, a round-robin scheduler will be
  used with a time quantum of 10 units. If a process is preempted by a
  higher-priority process, the preempted process is placed at the end of the
  queue.

  + Show the scheduling order of the process using a Gantt chart.
  + What is the turnaround time for each process?
  + What is the waiting time for each process?
]

#figure(
  timeliney.timeline(show-grid: true, {
    import timeliney: *
    headerline(group(..range(14).map(it => str((it + 1) * 10))))
    taskgroup({
      task($P_1$, (0, 1), (2, 2.5))
      task(
        $P_2$,
        (
          from: 0,
          to: 1,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (1, 2),
        (3.5, 4.5),
      )
      task($P_3$, (2.5, 3.5), (5.5, 6.5), (9, 10), (11, 12), (13, 14))
      task(
        $P_4$,
        (
          from: 2.5,
          to: 4.5,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (4.5, 5.5),
        (8, 9),
      )
      task(
        $P_5$,
        (
          from: 4.5,
          to: 6.5,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (6.5, 7),
      )
      task(
        $P_6$,
        (
          from: 5.5,
          to: 7,
          style: (stroke: 1.2em + blue.lighten(80%)),
        ),
        (7, 8),
        (10, 11),
        (12, 13),
      )
    })
    milestone(at: 0, style: (stroke: (dash: "dashed")), [$P_1\ P_2$])
    milestone(at: 1, style: (stroke: (dash: "dashed")), [$P_2\ P_1$])
    milestone(at: 2, style: (stroke: (dash: "dashed")), [$P_1\ P_3\ P_2$])
    milestone(at: 2.5, style: (stroke: (dash: "dashed")), [$P_3\ P_2\ P_4$])
    milestone(at: 3.5, style: (stroke: (dash: "dashed")), [$P_2\ P_4\ P_3$])
    milestone(at: 4.5, style: (stroke: (dash: "dashed")), [$P_4\ P_3\ P_5$])
    milestone(
      at: 5.5,
      style: (stroke: (dash: "dashed")),
      [$P_3\ P_5\ P_6\ P_4$],
    )
    milestone(
      at: 6.5,
      style: (stroke: (dash: "dashed")),
      [$P_5\ P_6\ P_4\ P_3$],
    )
    milestone(at: 7, style: (stroke: (dash: "dashed")), [$P_6\ P_4\ P_3$])
    milestone(at: 8, style: (stroke: (dash: "dashed")), [$P_4\ P_3\ P_6$])
    milestone(at: 9, style: (stroke: (dash: "dashed")), [$P_3\ P_6$])
    milestone(at: 10, style: (stroke: (dash: "dashed")), [$P_6\ P_3$])
    milestone(at: 11, style: (stroke: (dash: "dashed")), [$P_3\ P_6$])
    milestone(at: 12, style: (stroke: (dash: "dashed")), [$P_6\ P_3$])
    milestone(at: 13, style: (stroke: (dash: "dashed")), [$P_3\ P_6$])
    milestone(at: 14, style: (stroke: (dash: "dashed")), [$P_6\ P_3$])
  }),
)
The turnaround and wait times are on the next page
#grid(
  columns: 2,
  figure(
    table(
      columns: 4,
      table.header([*Process*], [*$t_A$*], [*$t_C$*], [*$t_"TA"$*]),
      $P_1$, $0$, $25$, $25$,
      $P_2$, $0$, $50$, $50$,
      $P_3$, $20$, $140$, $120$,
      $P_4$, $25$, $90$, $65$,
      $P_5$, $45$, $70$, $25$,
      $P_6$, $55$, $130$, $75$,
    ),
    caption: [Turnaround times (ms) of each process for each scheduling
      algorithm],
  ),
  figure(
    table(
      columns: 4,
      table.header([*Process*], [*$t_"TA"$*], [*$t_B$*], [*$t_W$*]),
      $P_1$, $25$, $15$, $10$,
      $P_2$, $50$, $20$, $30$,
      $P_3$, $120$, $20$, $100$,
      $P_4$, $65$, $20$, $45$,
      $P_5$, $25$, $5$, $20$,
      $P_6$, $75$, $15$, $60$,
    ),
    caption: [Waiting times (ms) of each process for each scheduling algorithm],
  ),
)


#problem("5.20")[
  Which of the following scheduling algorithsm could result in starvation?

  + First-come, first-served
  + Shortest job first
  + Round-robin
  + Priority
]

- Shortest job first causes starvations for long jobs that arrive early.
- Round robin also starves tasks if there is a long queue when a new task is
  added, or if the quantum is too long.
- Priority starves low-priority tasks that arrive early and have a long burst
  time

#problem("5.21")[
  Consider a variant of the RR scheduling algorithm in which the entries in the
  ready queue are pointers to the PCBs.

  + What would be the effect of putting two pointers to the same process in the
    ready queue?
  + What would be two major advantages and two disadvantages of this scheme?
  + How would you modify the basic: RR algorithm to achieve the same effect
    without the duplicate pointers?
]

Putting two pointers at the same process in the ready queue means that the
process would be marked for execution twice during each complete cycle of the
queue (more CPU time).

One advantage of this is that it provides an easy way to implement a priority
system: higher-priority processes get more pointers in the queue. Another
advantage is that it would increase the responsiveness for interactive CPU
tasks.

One disadvantage of this is that this increaeses the size of hte circular queue,
which means more management overhead for the scheduler. Another disadvantage is
that this would increase the waiting time for processes with fewer pointers
(starvation).

A way to implement the RR for the same effect is to have a variable quanta
depending dependent on task priority.

#important[
  Too tired to continue. Goodnight :)
]

#problem("5.22")[
  Consider a system running ten I/O-bound tasks and one CPU-bound task. Assume
  that the I/O-bound tasks issue an I/O operation once for every millisecond of
  CPU computing and that each I/O operation takes $10"ms"$ to complete. Also
  assume that the context-switching overhead is $100mu"s"$ and that all
  processes are long-running tasks. Describe the CPU utilization for a
  round-robin scheduler when:

  + The time quantum is $1"ms"$
  + The time quantum is $10"ms"$
]

#problem("5.26")[
  Describe why a shared ready queue might suffer from performance problems in an
  SMP environment.
]

#problem("5.28")[
  Assume that an SMP system has private, per-processor run queues. When a new
  process is created, it can be placed in either the same queue as the parent
  process or a separate queue.

  + What are the benefits of placing the new process in the same queue as its
    parent?
  + What are the benefits of placing the new process in a different queue?
]

#bibliography("../references.yaml")
