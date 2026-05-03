#import "common.typ": *
#import "@preview/unify:0.7.1": num, qty
#import "/projects/hw11/algorithms.typ": *
#import "@preview/lovelace:0.3.1": pseudocode-list

#let sep = line(length: 100%)
#let symbols = (
  ma: $"ma"$,
  ma-cache: $"ma"_"cache"$,
)
#let data = (
  "10.8": (refs: (1, 2, 3, 4, 2, 1, 5, 6, 2, 1, 2, 3, 7, 6, 3, 2, 1, 2, 3, 6)),
  "10.9": (refs: (7, 2, 3, 1, 2, 5, 3, 4, 6, 7, 7, 1, 0, 5, 4, 6, 2, 3, 0, 1)),
  "10.24": (
    refs: (
      (2, 6, 9, 2, 4, 2, 1, 7, 3, 0, 5, 2, 1, 2, 9, 5, 7, 3, 8, 5),
      (0, 6, 3, 0, 2, 6, 3, 5, 2, 4, 1, 3, 0, 6, 1, 4, 2, 3, 5, 7),
      (3, 1, 4, 2, 5, 4, 1, 3, 5, 2, 0, 1, 1, 0, 2, 3, 4, 5, 0, 1),
      (4, 2, 1, 7, 9, 8, 3, 5, 2, 6, 8, 1, 0, 7, 2, 4, 1, 3, 5, 8),
      (0, 1, 2, 3, 4, 4, 3, 2, 1, 0, 0, 1, 2, 3, 4, 4, 3, 2, 1, 0),
    ),
  ),
  "2": (refs: (7, 0, 1, 2, 0, 3, 0, 4, 2, 3, 0, 3, 2)),
)
#let arr-to-raw(arr) = raw(block: true, arr.map(n => str(n)).join(", "))

#problem("1")[
  A virtual memory system has these specifications: Memory access time is #qty(
    "50",
    "ns",
  ). TLB access time is #qty("2", "ns") with a hit ratio of #qty("98", "%").
  Page fault probability is $10^(-4)$ per page table accesses. It takes #qty(
    "5",
    "ms",
  ) to transfer a page from disk to memory or vice versa.

  + What is the effective memory access time? (Consider one-way page transfers.)
  + Assume that #qty("80", "%") of memory accesses are READ operations. What is
    the effective memory access time?
  + We use cache memory to speed up effective memory access time. The cache
    memory has an access time of #qty("10", "ns"), and a hit ratio of 90%. The
    penalty to miss in cache is #qty("200", "ns"). Compute effective memory
    access time with cache memory under the assumptions of parts (a) and (b).
]

The formula for *effective access time* is shown below:

$
  "effective access time" = (1 - p) times #symbols.ma + p times "page fault time"
$

Where #symbols.ma is the _memory access time_, and $p$ is the probability of a
page fault ($0<=p<=1$).

The constants that we are given are...
$#symbols.ma = (qty("98", "%") times (qty("50", "ns") + qty("2", "ns")) +
  qty("2", "%") times (2 times qty("50", "ns") + qty("2", "ns"))) = #qty("53", "ns")$,
$p=10^(-4)$, and $"page fault time"=qty("5", "ms") = qty("5e6", "ns")$

The effective access time of the system is
$(1 - 10^(-4)) times qty("53", "ns") + 10^(-4) times qty("5e6", "ns") = qty("552.9947", "ns")$.

Assuming that #qty("80", "%") of the memory accesses are `READ` operations, the
effective memory access time is

#sep

`WRITE` operations take twice as long (#qty("10", "ms")) as `READ` operations
(#qty("5", "ms")). Let's calculate the new page fault time:
$"page fault time" = qty("80", "%") times qty("5", "ms") + qty("20", "%")
times qty("10", "ms") = qty("6", "ms")$

That gives us an effective access time of
$(1 - 10^(-4)) times qty("53", "ns") + 10^(-4) times qty("6e6", "ns") = qty("652.9947", "ns")$.

#sep

We need to calculate the cache's memory access time:

$#symbols.ma-cache = qty("90", "%") times qty("10", "ns") + qty("10", "%") times
(qty("200", "ns") + qty("10", "ns")) = qty("30", "ns")$

That gives us an effective access time of
$(1 - 10^(-4)) times qty("30", "ns") + 10^(-4) times qty("6e6", "ns") = qty("629.997", "ns")$.


#problem("10.1")[
  Under what circumstances do page faults occur? Describe the actions taken by
  the operating system when a page fault occurs.
]

According to the textbook@os-concepts[Sec. 10.2.1], page faults occur when a
process tries to access a page that wasn't yet brought into memory. The
procedure for handling a page fault is as follows

#figure(
  pseudocode-list[
    + Check process's internal table to check if reference was invalid
    + *if* reference invalid
      + Terminate process.
    + *else*
      + Page in reference if it hasn't been brought in yet.
    + *end*
    + Find a free frame.
    + Schedule secondary storage to read desired page into that frame.
    + Modify internal table and page table to indicate that page is in memory.
    + Restart instruction that was interrupted by trap.
  ],
  caption: [Page fault procedure],
)<figure:10.1:page-fault-procedure>

#problem("10.2")[
  Assume that you have a page-reference string for a process with $m$ frames
  (initially all empty). The page-reference string has length $p$, and $n$
  distinct page numbers occur in it. Answer these questions for any
  page-replacement algorithms:

  + What is a lower bound on the number of page faults?
  + What is an upper bound on the number of page faults?
]

The lower bound (or minimum) amount of page faults that must occur are $n$ page
faults. The reason being is that the the $n$ pages are initially empty, so the
first time they are referenced _will_ cause a page fault to occur.

The upper bound (or maximum) amount of page faults that would occur is $p$,
where every reference in the string causes a fault to occur.

#problem("10.5")[
  Consider @table:10.5:page-table. The list of free page frames is `D`, `E`, and
  `F` (where `D` is the head of the list, and `F` is the last). A blank for a
  page frame indicates that the page is not in memory. Convert the following
  virtual addresses to their equivalent physical addresses in hexadecimal. All
  numbers are given in hexadecimal: `0x9EF`, `0x111`, `0x700`, `0x0FF`.

  #figure(
    table(
      columns: 2,
      table.header([*Page*], [*Page Frame*]),
      $0$, table.cell(fill: luma(70%))[],
      $1$, `0x2`,
      $2$, `0xC`,
      $3$, `0xA`,
      $4$, table.cell(fill: luma(70%))[],
      $5$, `0x4`,
      $6$, `0x3`,
      $7$, table.cell(fill: luma(70%))[],
      $8$, `0xB`,
      $9$, `0x0`,
    ),
    caption: [
      A Page table for a system with 12-bit virtual and physical addresses and
      256-byte pages
    ],
  )<table:10.5:page-table>
]

#figure(
  table(
    columns: 5,
    table.header(
      [*Virtual Address*],
      [*Page \#*],
      [*Frame \#*],
      [*Offset*],
      [*Virtual Address*],
    ),
    `0x9EF`, $9$, `0x0`, `EF`, `0x0EF`,
    `0x111`, $1$, `0x2`, `11`, `0x211`,
    `0x700`, $7$, `0xD`, `00`, `0xD00`,
    `0x0FF`, $0$, `0xE`, `FF`, `0xEFF`,
  ),
  caption: [
    Conversion table from virtual memory addresses to physical memory addresses.
  ],
)

#problem("10.6")[
  Discuss the hardware functions required to support demand paging.
]

The hardware functions required were mentioned in
@figure:10.1:page-fault-procedure:

- Page table with (in)valid bit
- Secondary storage (swap space)
- Instruction restart capability
- Memory management unit and TLB
- Modification/dirty bit

#problem("10.7")[
  Consider the two-dimensional array ```c int A[][] = new int[100][100];```,
  where ```c A[0][0]``` is at location `200` in a paged memory system with pages
  of size `200`. A small process that manipulates the matrix resides in page $0$
  (locations `0`#sym.arrow.r`199`). Thus, every instruction fetch will be from
  page $0$. For three page frames, how many page faults are generated by the
  following array-initialization loops? Use `LRU` placement, and assume that
  page frame `1` contains the process and the other two are initially empty.

  + #figure(
      ```c
      for (int j = 0; j < 100; j++)
        for (int i = 0; i < 100; i++)
          A[i][j] = 0;
      ```,
      caption: [Column-row matrix access program],
    )<listing:10.7:column-first>

  + #figure(
      ```c
      for (int i = 0; i < 100; j++)
        for (int j = 0; j < 100; i++)
          A[i][j] = 0;
      ```,
      caption: [Row-column matrix access program],
    )<listing:10.7:row-first>
]

Let's figure out the memory layout, given ```c sizeof(int)```$= 4 "bytes"$:

- A page size of `200` means 50 integers per page
- The matrix size means that there are $100^2 "integers" times "page"/(50
  "integers")=200$ pages
- Three page frames: one for the process, and two for uninitialized data

For the first process, iterating column-first means that for a fixed `j`, the
inner loop walks down every row, accessing `A[0][j]`, `A[1][j]`, `A[2][j]`, and
so on. Since each row occupies its own pair of pages, every step of the inner
loop lands on a different page. With only two data frames available, each new
page immediately evicts the last under LRU, so every single element access
causes a page fault. This gives 100 faults for each of the 100 columns, for a
total of $100 times 100 = #num(10000)$ page faults.

For the second process (@listing:10.7:row-first), each row spans two pages,
meaning that both data frames are being taken up. Since both frames are evicted
when a new row is loaded, that means that there are $100 times 2 = 200$ page
faults in this program.

#pagebreak()
#problem("10.8")[
  Consider the following page reference string:

  #arr-to-raw(data.at("10.8").refs)

  How many page faults would occur for the following replacement algorithms,
  assuming one, two, three, four, five, six, and seven frames? Remember that all
  frames are initially empty, so your first unique pages will cost one fault
  each.

  - LRU replacement
  - FIFO replacement
  - Optimal replacement
]


#(
  data
    .at("10.8")
    .insert("results", (
      "lru": range(0, 7).map(it => lru(data.at("10.8").refs, it + 1)),
      "fifo": range(0, 7).map(it => fifo(data.at("10.8").refs, it + 1)),
      "optimal": range(0, 7).map(it => optimal(data.at("10.8").refs, it + 1)),
    ))
)


#figure(
  table(
    columns: data.at("10.8").refs.len() + 1,
    table.header(
      [*\# Frames*],
      ..data.at("10.8").refs.map(n => [*#raw(str(n))*]),
    ),
    ..for (idx, faults) in data
      .at("10.8")
      .results
      .lru
      .map(it => it.faults)
      .enumerate() {
      // convert into arrays of strings
      let run = idx + 1
      let cells = faults.map(fault => if fault {
        table.cell(fill: luma(70%))[]
      } else { table.cell()[] })
      ($#run$, ..cells)
    },
  ),
  caption: [
    LRU algorithm for the reference string in @problem:10.8. Gray cells indicate
    a page fault, while white cells indicate a hit
  ],
)

#figure(
  table(
    columns: data.at("10.8").refs.len() + 1,
    table.header(
      [*\# Frames*],
      ..data.at("10.8").refs.map(n => [*#raw(str(n))*]),
    ),
    ..for (idx, faults) in data
      .at("10.8")
      .results
      .fifo
      .map(it => it.faults)
      .enumerate() {
      // convert into arrays of strings
      let run = idx + 1
      let cells = faults.map(fault => if fault {
        table.cell(fill: luma(70%))[]
      } else { table.cell()[] })
      ($#run$, ..cells)
    },
  ),
  caption: [
    FIFO algorithm for the reference string in @problem:10.8. Gray cells
    indicate a page fault, while white cells indicate a hit
  ],
)

#figure(
  table(
    columns: data.at("10.8").refs.len() + 1,
    table.header(
      [*\# Frames*],
      ..data.at("10.8").refs.map(n => [*#raw(str(n))*]),
    ),
    ..for (idx, faults) in data
      .at("10.8")
      .results
      .optimal
      .map(it => it.faults)
      .enumerate() {
      // convert into arrays of strings
      let run = idx + 1
      let cells = faults.map(fault => if fault {
        table.cell(fill: luma(70%))[]
      } else { table.cell()[] })
      ($#run$, ..cells)
    },
  ),
  caption: [
    Optimal algorithm for the reference string in @problem:10.8. Gray cells
    indicate a page fault, while white cells indicate a hit
  ],
)

In summary, the page faults for each algorithm would look like this:
#figure(
  table(
    columns: 4,
    table.header([*\# Frames*], [*LRU*], [*FIFO*], [*Optimal*]),
    ..range(7)
      .map(it => {
        let run = it + 1
        let current-lru = data.at("10.8").results.lru.at(it)
        let current-fifo = data.at("10.8").results.fifo.at(it)
        let current-optimal = data.at("10.8").results.optimal.at(it)
        (
          $#run$,
          raw(str(current-lru.faults.filter(f => f).len())),
          raw(str(current-fifo.faults.filter(f => f).len())),
          raw(str(current-optimal.faults.filter(f => f).len())),
        )
      })
      .flatten(),
  ),
)

#problem("10.9")[
  Consider the following page reference string:

  #arr-to-raw(data.at("10.9").refs)

  Assuming demand paging with three frames, how many page faults would occur for
  the following replacement algorithms?

  - LRU replacement
  - FIFO replacement
  - Optimal replacement
]

#(
  data
    .at("10.9")
    .insert("results", (
      "lru": lru(data.at("10.9").refs, 3),
      "fifo": fifo(data.at("10.9").refs, 3),
      "optimal": optimal(data.at("10.9").refs, 3),
    ))
)

#figure(
  table(
    columns: data.at("10.9").refs.len() + 2,
    table.header(
      [*Algorithm*],
      ..data.at("10.9").refs.map(n => [*#raw(str(n))*]),
      [*\# Faults*],
    ),
    ..(
      ("LRU", data.at("10.9").results.lru),
      ("FIFO", data.at("10.9").results.fifo),
      ("Optimal", data.at("10.9").results.optimal),
    )
      .map(pair => {
        let (algorithm, result) = pair
        let faults = result.faults

        let cells = faults.map(fault => if fault {
          table.cell(fill: luma(70%))[]
        } else { table.cell()[] })

        let num-faults = faults.filter(f => f).len()

        (algorithm, ..cells, str(num-faults))
      })
      .flatten()
  ),
  caption: [
    Algorithm results for the reference string in @problem:10.9. Gray cells
    indicate a page fault, while white cells indicate a hit
  ],
)

#problem("10.13")[
  Consider a demand-paged computer system where the degree of multiprogramming
  is currently fixed at four. The system was recently measured to determine
  utilization of the CPU and the paging disk. Three alternative results are
  shown below. For each case, what is happening? Can the degree of
  multiprogramming be increased to increase the CPU utilization? Is the paging
  helping?

  #figure(
    table(
      columns: 3,
      table.header([], [*CPU Utilization*], [*Disk Utilization*]),
      [A], qty("13", "%"), qty("97", "%"),
      [B], qty("87", "%"), qty("3", "%"),
      [C], qty("13", "%"), qty("3", "%"),
    ),
  )
]

In the first scenario, the system is experiencing *thrashing*, since the system
is spending a lot of time paging data in and out of swap (the #qty("97", "%")
disk utilization), and very little time executing instructions (the #qty(
  "3",
  "%",
)).

The degree of multiprogramming shouldn't be increased, as it would only make the
thrashing worse.

Paging is the reason this programming is experiencing *thrashing*.

#sep

In the second scenario, the system is working efficiently. The degree of
multiprogramming could be increased to increase the CPU utilization, but the
effects would not be as substantial as the CPU utilization is already high.

Paging is helping this system by keeping the actively used portions of the four
processes in memory.

#sep

In the third scenario, both the CPU and disk are being underutilized. The degree
of multiprogramming should be increased to increase the CPU utilization. Paging
is helping here as it's the reason why the disk usage is low.

#pagebreak()
#problem("10.15")[
  Assume that a program has just referenced an address in virtual memory.
  Describe a scenario in which each of the following can occur. (If no such
  scenario can occur, explain why.)

  - TLB miss with no page fault
  - TLB miss with page fault
  - TLB hit with no page fault
  - TLB hit with page fault
]

A scenario where TLB misses with no page fault is when the CPU looks for a
virtual-to-physical address translation in the TLB but doesn't find it (miss).
It then checks the page table in main memory and finds that the page is indeed
present in a physical frame.
#sep
A scenario where TLB misses with a page fault is when the CPU looks in the TLB
and misses. It then checks the page table and finds that the page isn't in
physical memory.
#sep
A scenario where TLB hits with no page fault is when the CPU looks in the TLB
and finds the translation immediately.
#sep
A scenario where TLB hits with no page fault can't occur. If a translation
exists in the TLB, then the page *must* be present in physical memory.

#pagebreak()
#problem("10.16")[
  A simplified view of thread states is ready, running and blocked, where a
  thread is either ready and waiting to be scheduled, is running on the
  processor, or is blocked (for example, waiting for I/O).

  Assuming a thread is in the running state, answer the following questions, and
  explain your answers:

  + Will the thread change state if it incurs a page fault? If so, to what state
    will it change?
  + Will the thread change state if it generates a TLB miss that is resolved in
    the page table? If so, to what state will it change?
  + Will the thread change state if an address reference is resolved in the page
    table? If so, to what state will it change?
]

The thread will change state (`running`#sym.arrow.r`blocked`) if it incurs a
page fault. The required data isn't in physical RAM and disk access is a
CPU-expensive operation, the CPU moves the thread to `blocked`, and schedules a
`ready` process to run. Once the page is loaded into memory, the process is
marked `ready` again.
#sep
The thread won't change state if it generates a TLB miss that's resolved in the
page table. Even though the TLB misses and the CPU has to look through physical
RAM, that operation is quick enough that the CPU won't change the thread's
state.
#sep
The thread won't change state if an address reference is resolved

#problem("10.17")[
  Consider a system that uses pure demand paging.

  + When a process first starts execution, how would you characterize the
    page-fault rate?
  + Once the working set for a process is loaded into memory, how would you
    characterize the page-fault rate?
  + Assume that a process changes its locality and the size of the new working
    set is too large to be stored in available free memory. Identify some
    options system designers could choose from to handle this situation.
]

When the process first starts execution, the page-fault rate is extremely high.
This is because a process starts with zero pages in physical memory. The first
CPU instruction executed, and the first piece of data it tries to read results
in page faults.
#sep
Once the working set for a process is loaded into memory, the page-fault rate is
low. The process will often-times access the same code and data it has already
been requiring, so those pages are already in physical memory.
#sep
Some options system designers can use to handle that situation is to...
- lower the degree of multiprogramming
- use a page-fault frequency strategy, where the OS allocates more frames if a
  process's fault rate exceeds a certain threshold.
- the process can get more frames from other processes, or only manage its pages
  within its local allocated frames

#problem("10.18")[
  Consider @table:10.18:page-table. Free page frames are to be allocated in the
  order `9`, `F`, `D`. A blank for a page frame indicates that the page is not
  in memory.

  #figure(
    table(
      columns: 2,
      table.header([*Page*], [*Page Frame*]),
      $0$, `0x4`,
      $1$, `0xB`,
      $2$, `0xA`,
      $3$, table.cell(fill: luma(70%))[],
      $4$, table.cell(fill: luma(70%))[],
      $5$, `0x2`,
      $6$, table.cell(fill: luma(70%))[],
      $7$, `0x0`,
      $8$, `0xC`,
      $9$, `0x1`,
    ),
    caption: [
      A Page table for a system with 12-bit virtual and physical addresses and
      256-byte pages
    ],
  )<table:10.18:page-table>

  Convert the following virtual addresses to their equivalent physical addresses
  in hexadecimal. All numbers are given in hexadecimal. In the case of a page
  fault, you must use one of the free frames to update the page table and
  resolve the logical address to its corresponding physical address.

  - `0x2A1`
  - `0x4E6`
  - `0x94A`
  - `0x316`
]

#figure(
  table(
    columns: 5,
    table.header(
      [*Virtual Address*],
      [*Page \#*],
      [*Frame \#*],
      [*Offset*],
      [*Virtual Address*],
    ),
    `0x2A1`, $2$, `0xA`, `A1`, `0xAA1`,
    `0x4E6`, $4$, `0x9`, `E6`, `0x9E6`,
    `0x94A`, $9$, `0x1`, `4A`, `0x14A`,
    `0x316`, $3$, `0xF`, `16`, `0xF16`,
  ),
  caption: [
    Conversion table from virtual memory addresses to physical memory addresses.
  ],
)

#problem("10.20")[
  A certain computer provides its users with a virtual memory space of $2^32$
  bytes. The computer has $2^(22)$ bytes of physical memory. The virtual memory
  is implemented by paging, and the page size is 4,096 bytes. A user process
  generates the virtual address `0x1112 3456`. Explain how the system
  establishes the corresponding physical location. Distinguish between software
  and hardware operations.
]

The system has `32` bits of virtual memory, and `22` bits of physical memory.
Given a page size of $2^(12)$, that gives an offset of `12` bits. The remaining
bits `32-12` represent the _virtual page number_, or VPN. The system establishes
the corresponding physical location by assigning the virtual page number to the
first 5 bits (from the right) as the VPN (`0x11123`), and the last 3 as the
offset (`0x456`).

The hardware operations involve...
- TLB lookup for the VPN. If it's a hit, then the physical frame number is
  retrieved immediately.
- If it's a miss, then the hardware looks at the page table in physical memory
- The hardware connects the page frame number (`PFN`) with the offset
- Then the hardware requests access to the physical RAM address.

The software operations involve page fault handling and context switching.


#problem("10.21")[
  Assume that we have a demand-paged memory. The page table is held in
  registers. It takes #qty("8", "ms") to service a page fault if an empty frame
  is available or if the replaced page is not modified and #qty("20", "ms") if
  the replaced page is modified. Memory-access time is #qty("100", "ns"). Assume
  that the page to be replaced is modified #qty("70", "%") of the time. What is
  the maximum acceptable page-fault rate for an effective access time of no more
  than #qty("200", "ns")?
]

Let's define our constants. The effective access time, $T$ is #qty("200", "ns").
The memory access time, #symbols.ma, is #qty("100", "ns"). The page fault time
is
$(qty("70", "%") times qty("20", "ms")) + (qty("30", "%") times
  qty("8", "ms"))=qty("16.4", "ms")=qty("16.4e6", "ns")$

The maximum acceptable page-fault rate can be solved using the equation for
effective access time, where $T$ is the effective access time, and $P$ is the
page fault time:

$
  T & = (1 - p) times #symbols.ma + p times P \
  T & = #symbols.ma - p times #symbols.ma + p times P \
  T & = p (P - #symbols.ma) + #symbols.ma \
  p & = (T - #symbols.ma) / (P - #symbols.ma) \
    & = (qty("200", "ns") - qty("100", "ns")) / (qty("16.4e6", "ns") -
      qty("100", "ns")) \
  p & = 1 / num("163999")
$

The maximum acceptable page-fault rate is 1 fault per #num("163999") memory
accesses.

#problem("10.22")[
  Consider @table:10.22:page-table.

  #figure(
    table(
      columns: 3,
      table.header([*Page*], [*Page Frame*], [*Reference Bit*]),
      $0$, `0x9`, `0`,
      $1$, table.cell(fill: luma(70%))[], `0`,
      $2$, `0xA`, `0`,
      $3$, `0xF`, `0`,
      $4$, `0x6`, `0`,
      $5$, `0xD`, `0`,
      $6$, `0x8`, `0`,
      $7$, `0xC`, `0`,
      $8$, `0x7`, `0`,
      $9$, table.cell(fill: luma(70%))[], `0`,
      $10$, `0x5`, `0`,
      $11$, table.cell(fill: luma(70%))[], `0`,
      $12$, `0x1`, `0`,
      $13$, `0x0`, `0`,
      $14$, table.cell(fill: luma(70%))[], `0`,
      $15$, `0x2`, `0`,
    ),
    caption: [
      A Page table for a system with 16-bit virtual and physical addresses and
      4096-byte pages
    ],
  )<table:10.22:page-table>
  The reference bit for a page is set to `1` when the page has been referenced.
  Periodically, a thread zeroes out all values of the reference bit. A dash for
  a page frame indicates that the page is not in memory. The page-replacement
  algorithm is localized `LRU`, and all numbers are provided in hexadecimal.

  + Convert the following virtual addresses (in hexadecimal) to the equivalent
    physical addresses. You may provide answers in either hexadecimal or
    decimal. Also set the reference bit for the appropriate entry in the page
    table: `0x621C`, `0xF0A3`, `0xBC1A`, `0x5BAA`, `0x0BA1`
  + Using the above addresses as a guide, provide an example of a logical
    address (in hexadecimal) that results in a page fault.
  + From what set of page frames will the `LRU` page-replacement algorithm
    choose in resolving a page fault?
]

#figure(
  table(
    columns: 5,
    table.header(
      [*Virtual Address*],
      [*Page \#*],
      [*Frame \#*],
      [*Offset*],
      [*Physical Address*],
    ),
    `0x621C`, $6$, `0x8`, `21C`, `0x821C`,
    `0xF0A3`, $F$, `0x2`, `0A3`, `0x20A3`,
    `0xBC1A`, $B$, table.cell(fill: luma(70%))[], `C1A`, [Page Fault],
    `0x5BAA`, $5$, `0xD`, `BAA`, `0xDBAA`,
    `0x0BA1`, $0$, `0x9`, `BA1`, `0x9BA1`,
  ),
  caption: [
    Conversion table from virtual memory addresses to physical memory addresses.
  ],
)
The reference bits for page numbers $6$, $15$, $11$, $5$, and $0$ were set to
`1`.

Any address starting with `0x1`, `0x9`, `0xB`, and `0xE` would result in a page
fault, as there is no page frame assigned that that page.

The set of page frames the `LRU` page-replacement algorithm will choose in
resolve a page fault would be the frame that was least-recently used among the
ones in @table:10.22:page-table.

#pagebreak()
#problem("10.24")[
  Apply the (1) FIFO, (2) LRU, and (3) optimal (OPT) replacement algorithms for
  the following page-reference strings:

  #list(..data.at("10.24").refs.map(r => arr-to-raw(r)))

  Indicate the number of page faults for each algorithm assuming demand paging
  with three frames.
]

#{
  data.at("10.24").insert("results", ())
  for refs in data.at("10.24").refs {
    data
      .at("10.24")
      .results
      .push((
        lru: lru(refs, 3),
        fifo: fifo(refs, 3),
        optimal: optimal(refs, 3),
      ))
  }
}

#figure(
  table(
    columns: data.at("10.24").refs.first().len() + 2,
    ..data
      .at("10.24")
      .refs
      .enumerate()
      .map(pair => {
        let (index, refs) = pair
        let header-algorithm = if index == 0 { [*Algorithm*] } else { [] }
        let header-num-faults = if index == 0 { [*\# Faults*] } else { [] }
        (
          table.header(
            header-algorithm,
            ..refs.map(r => [*#raw(str(r))*]),
            header-num-faults,
          ),
          ..(
            ("LRU", data.at("10.24").results.at(index).lru),
            ("FIFO", data.at("10.24").results.at(index).fifo),
            ("Optimal", data.at("10.24").results.at(index).optimal),
          )
            .map(pair => {
              let (algorithm, result) = pair
              let faults = result.faults

              let cells = faults.map(fault => if fault {
                table.cell(fill: luma(70%))[]
              } else { table.cell()[] })

              let num-faults = faults.filter(f => f).len()

              (algorithm, ..cells, str(num-faults))
            })
            .flatten(),
        )
      })
      .flatten()
  ),
  caption: [
    Algorithm results for the reference string in @problem:10.24. Gray cells
    indicate a page fault, while white cells indicate a hit
  ],
)

#problem("10.29")[
  Consider a demand-paging system with the following time-measured utilizations:

  #figure(
    table(
      columns: 2,
      align: left,
      [CPU utilization], qty("20", "%"),
      [Paging disk], qty("97.7", "%"),
      [Other I/O devices], qty("5", "%"),
    ),
  )

  For each of the following, indicate whether it will (or is likely to) improve
  CPU utilization. Explain your answers.

  + Install a faster CPU.
  + Install a bigger paging disk.
  + Increase the degree of multiprogramming.
  + Decrease the degree of multiprogramming.
  + Install more main memory.
  + Install a faster hard disk or multiple controllers with multiple hard disks.
  + Add pre-paging to the page-fetch algorithms.
  + Increase the page size.
]

A faster CPU just means that it'll reach #qty("20", "%") CPU utilization
quicker.

A bigger paging disk provides more page space, but it doesn't help the pages
load into RAM any quicker.

Increasing the degree of multiprogramming will worsen CPU utilization, as each
process requires its own frames, resulting in stealing from other frames and
causing the page-fault rate to climb higher. Decreasing the degree of
multiprogramming would help with the CPU utilization, however.

Installing more main memory (RAM) would address the root cause of the high
paging disk utilization, increasing the CPU usage.

A faster hard disk / multiple controllers with multiple hard disks would reduce
the time waiting for faults, which increases the CPU utilization rate.

Pre-paging helps to prevent future page-faults and reduces the number of times
the CPU has to stop and wait for the disk, which increases CPU utilization rate.

Increasing the page size just lead to more internal fragmentation, making
thrashing likelier.

#problem("10.36")[
  Consider a demand-paging system with a paging disk that has an average access
  and transfer time of #qty("20", "ms"). Addresses are translated through a page
  table in main memory, with an access time of #qty("1", "us") per memory
  access. Thus, each memory reference through the page table takes two accesses.
  To improve this time, we have added an associative memory that reduces access
  time to one memory reference if the page-table entry is in the associative
  memory. Assume that #qty("80", "%") of the accesses are in the associative
  memory and that, of those remaining, #qty("10", "%") (or #qty("2", "%") of the
  total) cause page faults. What is the effective memory access time?
]

Given the $#symbols.ma = qty("1", "us")$, a TLB hit time of #qty("1", "us"), a
TLB miss time of #qty("2", "us"), and a page-fault time of #qty("20", "ms"), or
#qty("20e3", "us"), we get...

$
  "EAT" & = #qty("80", "%") times qty("1", "us") + qty("18", "%") times qty(
            "2",
            "us"
          ) + qty("2", "%") times qty("20002", "us") = qty("401.2", "us")
$

An effective memory access time of #qty("401.2", "us")

#problem("2")[
  Consider the following string of page references, and assume a 4-frame memory.

  #arr-to-raw(data.at("2").refs)

  Complete a figure similar to the one worked in class showing the frame
  allocation for:

  + FIFO (first-in-first-out)
  + LRU (least recently used)
  + Clock
  + Optimal (assume the page reference string continues with
    `1, 2, 0, 1, 7, 0, 1`)
  + List the total number of page faults and the miss rate for each policy.
    Count page faults only after all Frames have been initialized.
]

#{
  data
    .at("2")
    .insert("results", (
      "lru": lru(data.at("2").refs, 4),
      "fifo": fifo(data.at("2").refs, 4),
      "clock": clock(data.at("2").refs, 4),
      "optimal": optimal(data.at("2").refs + (1, 2, 0, 1, 7, 0, 1), 4)
        .pairs()
        .map(pair => (
          pair.first(),
          pair.last().slice(0, data.at("2").refs.len()),
        ))
        .to-dict(),
    ))
}

#figure(
  table(
    columns: data.at("2").refs.len() + 2,
    table.header(
      [*Algorithm*],
      ..data.at("2").refs.map(n => [*#raw(str(n))*]),
      [*\# Faults*],
    ),
    ..(
      ("LRU", data.at("2").results.lru),
      ("FIFO", data.at("2").results.fifo),
      ("clock", data.at("2").results.clock),
      ("optimal", data.at("2").results.optimal),
    )
      .map(pair => {
        let (algorithm, result) = pair
        let faults = result.faults

        let cells = faults.map(fault => if fault {
          table.cell(fill: luma(70%))[]
        } else { table.cell()[] })

        let num-faults = faults.filter(f => f).len()

        (algorithm, ..cells, str(num-faults))
      })
      .flatten()
  ),
  caption: [
    Algorithm results for the reference string in @problem:2. Gray cells
    indicate a page fault, while white cells indicate a hit
  ],
)

#pagebreak()
#counter(heading).step()
#bibliography("../references.yaml")

= Appendix

#{
  show figure: set block(breakable: true)
  figure(
    align(left, raw(
      read("/projects/hw11/algorithms.typ"),
      lang: "typ",
      block: true,
    )),
    caption: [Page-replacement algorithms implemented in the `typst` language],
  )
}
