#import "@local/callouts:0.1.0": answer, task
#import "common.typ": problem

#import "@preview/timeliney:0.4.0"

#problem("5.3")[
  Suppose that the following processes arrive for execution at the times
  indicated. Each process will run for the amount of time listed. In answering
  the questions, use non-preemptive scheduling, and base all decisions on the
  information you have at the time the decision must be made.

  #figure(
    table(
      columns: 3,
      table.header([*Process*], [*Arrival Time*], [*Burst Time*]),
      $P_1$, $0.0$, $8$,
      $P_2$, $0.4$, $4$,
      $P_3$, $1.0$, $1$,
    ),
    caption: [Process scheduling table for @problem:5.3],
  )

  + What is the average turnaround time for these processes with the FCFS
    scheduling algorithm?
  + What is the average turnaround time for these processes with the SJF
    scheduling algorithm?
  + The SJF algorithm is supposed to improve performance, but notice that we
    chose to run process $P_1$ at time 0 because we did not know that two
    shorter processes would arrive soon. Compute what the average turnaround
    time will be if the CPU is left idle for the first 1 unit and then SJF
    scheduling is used. Remember that processes $P_1$ and $P_2$ are waiting
    during this idle time, so their waiting time may increase. This algorithm
    could be known as first-knowledge-scheduling (FKS).
]

The formula for the average turnaround time is shown below:

$
  t_"TA" = (sum_(i=0)^N t_C[i] - t_A[i])/N
$
Where $N$ is the number of processes, $t_C$ is the completion time, and $t_A$ is
the arrival time. The Gantt charts of the three methods are shown in @figure:5.3

#figure(
  timeliney.timeline(show-grid: true, {
    import timeliney: *
    headerline(group(..range(14).map(it => str(it + 1))))
    taskgroup(title: [*FCFS*], {
      task($P_1$, (0, 8))
      task(
        $P_2$,
        (
          from: 0.4,
          to: 8,
          style: (stroke: 1.2em + blue.lighten(60%)),
          content: [*Waiting*],
        ),
        (from: 8, to: 12),
      )
      task(
        $P_3$,
        (
          from: 1,
          to: 12,
          style: (stroke: 1.2em + blue.lighten(60%)),
          content: [*Waiting*],
        ),
        (from: 12, to: 13),
      )
    })
    taskgroup(title: [*SJF*], {
      task($P_1$, (0, 8))
      task(
        $P_3$,
        (
          from: 1,
          to: 8,
          style: (stroke: 1.2em + blue.lighten(60%)),
          content: [*Waiting*],
        ),
        (from: 8, to: 9),
      )
      task(
        $P_2$,
        (
          from: 0.4,
          to: 9,
          style: (stroke: 1.2em + blue.lighten(60%)),
          content: [*Waiting*],
        ),
        (from: 9, to: 13),
      )
    })
    taskgroup(title: [*FKS*], {
      task(
        $P_3$,
        (
          from: 0,
          to: 1,
          style: (stroke: 1.2em + purple.lighten(60%)),
          content: [*Idle*],
        ),
        (from: 1, to: 2),
      )
      task(
        $P_2$,
        (
          from: 0.4,
          to: 2,
          style: (stroke: 1.2em + blue.lighten(60%)),
          content: [*Wait*],
        ),
        (2, 6),
      )
      task(
        $P_1$,
        (
          from: 0,
          to: 6,
          style: (stroke: 1.2em + blue.lighten(60%)),
          content: [*Wait*],
        ),
        (6, 6 + 8),
      )
    })
  }),
  caption: [Gantt Chart for the three parts described in @problem:5.3],
)<figure:5.3>

$
  t_"TA,FCFS" & = ((8 - 0) + (12 - 0.4) + (13 - 1))/ 3 & = 10.533 \
   t_"TA,SJF" & = ((8 - 0) + (9 - 1) + (13 - 0.4))/ 3  &  = 9.533 \
   t_"TA,FKS" & = ((2 - 1) + (12 - 0.4) + (13 - 1))/ 3 &    = 8.2 \
$

#problem("5.4")[
  Consider @problem:5.4 with the length of the CPU burst time given in
  milliseconds. The processes are assumed to have arrived in the order $P_1$,
  $P_2$, $P_3$, $P_4$, $P_5$, all at $0 "ms"$
  #figure(
    table(
      columns: 3,
      table.header([*Process*], [*Burst Time*], [*Priority*]),
      $P_1$, $2$, $2$,
      $P_2$, $1$, $1$,
      $P_3$, $8$, $4$,
      $P_4$, $4$, $2$,
      $P_5$, $5$, $3$,
    ),
    caption: [Process scheduling table for @problem:5.4],
  )

  + Draw four Gantt charts that illustrate the execution of these processes
    using the following scheduling algorithms:
    - FCFS
    - SJF
    - Non-preemptive priority (a larger priority number implies a higher
      priority)
    - RR (quantum=2)
  + What is the turnaround time of each process for each of the scheduling
    algorithms?
  + What is the waiting time of each proces for each of the scheduling
    algorithms?
  + Which of the algorithms results in the minimum average waiting time (over
    all processes?)
]

The Gantt chart for this problem can be seen in @figure:5.4.

#figure(
  table(
    columns: 6,
    table.header(
      [],
      ..range(5).map(it => {
        it += 1
        $P_#it$
      }),
    ),
    [FCFS], $2$, $3$, $11$, $15$, $20$,
    [SJF], $3$, $1$, $20$, $7$, $12$,
    [Priority], $15$, $20$, $8$, $19$, $13$,
    [RR], $2$, $3$, $20$, $13$, $18$,
  ),
  caption: [Turnaruond times (ms) of each process for each scheudling
    algorithm],
)

The waiting time is defined by the equation $t_"W"=t_"TA"-t_B$, where $t_B$ is
the burst time. From the below table, one can see that the SJF algorithm
produced the shorted minimum average waiting time (4.6).

#figure(
  table(
    columns: 7,
    table.header(
      [],
      ..range(5).map(it => {
        it += 1
        $P_#it$
      }),
      [Mean],
    ),
    //     2, 1, 8, 4, 5
    [FCFS], $0$, $2$, $3$, $11$, $15$, $6.2$,
    [SJF], $1$, $0$, $12$, $3$, $7$, $4.6$,
    [Priority], $13$, $19$, $0$, $15$, $8$, $11$,
    [RR], $0$, $2$, $12$, $9$, $13$, $7.2$,
  ),
  caption: [Waiting times (ms) of each process for each scheudling algorithm],
)

#figure(
  timeliney.timeline(show-grid: true, {
    import timeliney: *
    headerline(group(..range(20).map(it => str(it + 1))))
    taskgroup(title: [*FCFS*], {
      task($P_1$, (0, 2))
      task($P_2$, (2, 3))
      task($P_3$, (3, 11))
      task($P_4$, (11, 15))
      task($P_5$, (15, 20))
    })
    taskgroup(title: [*SJF*], {
      task($P_2$, (0, 1))
      task($P_1$, (1, 3))
      task($P_4$, (3, 7))
      task($P_5$, (7, 12))
      task($P_3$, (12, 20))
    })
    taskgroup(title: [*Priority*], {
      task($P_3$, (0, 8))
      task($P_5$, (8, 13))
      task($P_1$, (13, 15))
      task($P_4$, (15, 19))
      task($P_2$, (19, 20))
    })
    taskgroup(title: [*RR*], {
      task($P_1$, (0, 2))
      task($P_2$, (2, 3))
      task($P_3$, (3, 5), (9, 11), (15, 17), (18, 20))
      task($P_4$, (5, 7), (11, 13))
      task($P_5$, (7, 9), (13, 15), (17, 18))
    })
  }),
  caption: [Gantt Charts for @problem:5.4],
)<figure:5.4>

#problem("5.5")[
  @table:5.5 is being scheduled using a preemptive, round robin scheduling
  algorithm ($Q=10$). The system also has an idle task, $P_"idle"$ (priority of
  0), which consumes on CPU resources and is scheduled to run whenever no other
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
    milestone(at: 2, style: (stroke: (dash: "dashed")), [$P_1$ done])
    milestone(at: 7, style: (stroke: (dash: "dashed")), [$P_2$ done])
    milestone(at: 8.5, style: (stroke: (dash: "dashed")), [$P_3$ done])
    milestone(at: 9, style: (stroke: (dash: "dashed")), [$P_4$ done])
    milestone(at: 11, style: (stroke: (dash: "dashed")), [$P_5$ done])
    milestone(at: 12, style: (stroke: (dash: "dashed")), [$P_6$ done])
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
  caption: [Turnaround times (ms) of each process for each scheudling
    algorithm],
)
