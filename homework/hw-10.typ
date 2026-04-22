#import "common.typ": *
#import "@preview/unify:0.7.1": qty

#let problem-data = (
  "9.7": (
    page-size: calc.pow(2, 10),
    addresses: (3085, 42095, 215201, 650000, 2000001),
  ),
  "9.21": (
    page-size: calc.pow(2, 10),
    addresses: (21205, 164250, 121357, 16479315, 27253187),
  ),
)

#problem("9.1")[ Name two differences between logical and physical addresses. ]

+ Logical addresses start at 0, and is continuous
+ Physical addresses can start from anywhere and aren't continuous

#problem("9.2")[ Why are page sizes always powers of 2? ]

Page sizes are always powers of two because it makes the logical address into
page number and offset particularly easy.@os-concepts[p. 361]. An example from
the textbook as well:

#quote(attribution: [@os-concepts[p. 361]], block: true)[
  Given a logical address size of $2^m$ and a page size of $2^n$, then the page
  number would be $m-n$ and the page offset would be $n$
]

#problem("9.4")[
  Consider a logical address space of 64 pages of 1,024 words each, mapped onto
  a physical memory of 32 frames.

  + How many bits are there in the logical address?
  + How many bits are there in the physical address?
]

The formula for the number of bits in the logical and physical addresses are
shown below:

$
   n_"logical" & = log_2("words") + log_2("pages") \
  n_"physical" & = log_2("words") + log_2("frames")
$

So the number of bits in the logical address is $log_2(1024)+log_2(64)=16$ bits,
and the number of bits in the physical address is $log_2(1024)+log_2(32)=15$
bits.

#problem("9.6")[
  Given six memory partitions of #qty("300", "KiB"), #qty("600", "KiB"), #qty(
    "350",
    "KiB",
  ), #qty("200", "KiB"), #qty("750", "KiB"), and #qty("125", "KiB") in that
  order, how would the _first-fit_, _Best-fit_, and _worst-fit_ algorithms place
  processes of size #qty("115", "KiB"), #qty("500", "KiB"), #qty("358", "KiB"),
  #qty("200", "KiB"), and #qty("375", "KiB") in that order?
]

The algorithm specifications can be found in the textbook@os-concepts[Sec.
  9.2.2]. @table:9.6 gives labels to the processes and memory partitions, which
I'll use to help describe how each partition would handle place the processes.

#figure(
  table(
    columns: 4,
    table.header(
      table.cell(colspan: 2)[*Process*],
      table.cell(colspan: 2)[*Memory Partitions*],
    ),
    [*$P_1$*], qty("115", "KiB"), [*$M_1$*], qty("300", "KiB"),
    [*$P_2$*], qty("500", "KiB"), [*$M_2$*], qty("600", "KiB"),
    [*$P_3$*], qty("358", "KiB"), [*$M_3$*], qty("350", "KiB"),
    [*$P_4$*], qty("200", "KiB"), [*$M_4$*], qty("200", "KiB"),
    [*$P_5$*], qty("375", "KiB"), [*$M_5$*], qty("750", "KiB"),
    table.cell(colspan: 2, fill: luma(80%))[], [*$M_6$*], qty("125", "KiB"),
  ),
  caption: [
    Processes and memory partitions, labeled by their order of arrival (lower is
    earlier)
  ],
)<table:9.6>

Here's how each algorithm would place each process:

#grid(
  align: center + bottom,
  columns: 3,
  [#figure(
    $
      P_1 & -> M_1 \
      P_2 & -> M_2 \
      P_3 & -> M_4 \
      P_4 & -> M_3 \
      P_5 & -> nothing
    $,
    caption: [_First-fit_ algorithm],
  )<figure:9.6:first-fit>],
  [#figure(
    $
      P_1 & -> M_6 \
      P_2 & -> M_2 \
      P_3 & -> M_5 \
      P_4 & -> M_4 \
      P_5 & -> nothing
    $,
    caption: [_Best-fit_ algorithm],
  )<figure:9.6:best-fit>],
  [#figure(
    $
      P_1 & -> M_5 \
      P_2 & -> M_2 \
      P_3 & -> nothing \
    $,
    caption: [_Worst-fit_ algorithm],
  )<figure:9.6:worst-fit>],
),

@figure:9.6:first-fit and @figure:9.6:best-fit were able to fulfill 4/5 of the
process requests, whilst @figure:9.6:worst-fit only fulfilled 2/5 requests.

#pagebreak()
#problem("9.7")[
  Assuming a #qty("1", "KiB") page size, what are the page numbers and offsets
  for the following address references (provided as decimal numbers):

  #enum(..problem-data.at("9.7").addresses.map(it => str(it)))
]
The following formulas will be used to determine the page number and offset:
$
  "page"_\# & = floor("address" / "size"("page")) \
   "offset" & = "address" - "page" * "size"("page")
$

#figure(
  table(
    columns: 3,
    align: (_, y) => if y == 0 { center } else { left } + horizon,
    table.header([*Address Reference*], [*Page Number*], [*Offset*]),
    ..problem-data
      .at("9.7")
      .addresses
      .map(address => {
        let page = calc.quo(address, problem-data.at("9.7").page-size)
        let offset = address - page * problem-data.at("9.7").page-size

        ([#address], [#page], [#offset])
      })
      .flatten(),
  ),
)

#problem("9.8")[
  The BTV operating system has a 21-bit virtual address, yet on certain embedded
  devices, it has only a 16-bit physical address. It also has a #qty("2", "KiB")
  page size. How many entries are there in each of the following?

  + A conventional, single-level page table

  What is the maximum amount of physical memory in the BTV operating system?
]

For the conventional, single-level page table, this means that the page size of
#qty("2", "KiB") serves as the offset. The page size would be $21-11=10$ bits in
size, meaning that there are $2^(10)=1024$ entries.

The maximum amount of physical memory is determined by the total number of
addressable locations. With a 16-bit physical address, the system can address
$2^16$ bytes, which is #qty("64", "KiB")

#pagebreak()
#problem("9.9")[
  Consider a logical address space or 256 pages with a #qty("4", "KiB") page
  size, mapped onto a physical memory of 64 frames.

  + How many bits are required in the logical address?
  + How many bits are required in the physical address?
]

This can be solved in the same manner as @problem:9.4.

The number of bits in the logical address is
$log_2(qty("4", "KiB"))+log_2(256)=12+8=20$, whilst the number of bits required
in the physical address is $log_2(qty("4", "KiB"))+log_2("frames")=12+6=18$.

#problem("9.10")[
  Consider a computer system with a 32-bit logical address and #qty("4", "KiB")
  page size. The system supports up to 512 MB of physical memory. How many
  entries are there in each of the following?

  + A conventional, single-level page table
]

This is the same type of problem as @problem:9.8:

For a conventional, single-level page table, a page size of #qty("4", "KiB")
means that there are 12 bits. For a system with a 32-bit logical address, that
would be $32-log_2(qty("4", "KiB"))=20$ bits of entries (#calc.pow(2, 20)
entries)

#pagebreak()
#problem("9.13")[
  Given six memory partitions of #qty("100", "MiB"), #qty("170", "MiB"), #qty(
    "40",
    "MiB",
  ), #qty("205", "MiB"), #qty("300", "MiB"), and #qty("185", "MiB") (in order),
  how would the first-fit, best-fit, and worst-fit algorithms place processes of
  size #qty("200", "MiB"), #qty("15", "MiB"), #qty("185", "MiB"), #qty(
    "75",
    "MiB",
  ), #qty("175", "MiB"), and #qty("80", "MiB") (in order)? Indicate which-if
  any- requests cannot be satisfied. Comment on how efficiently each of the
  algorithms manages memory.
]

This is the same type of problem as @problem:9.6:

#figure(
  table(
    columns: 4,
    table.header(
      table.cell(colspan: 2)[*Process*],
      table.cell(colspan: 2)[*Memory Partitions*],
    ),
    [*$P_1$*], qty("200", "MiB"), [*$M_1$*], qty("100", "MiB"),
    [*$P_2$*], qty("15", "MiB"), [*$M_2$*], qty("170", "MiB"),
    [*$P_3$*], qty("185", "MiB"), [*$M_3$*], qty("40", "MiB"),
    [*$P_4$*], qty("75", "MiB"), [*$M_4$*], qty("205", "MiB"),
    [*$P_5$*], qty("175", "MiB"), [*$M_5$*], qty("300", "MiB"),
    [*$P_6$*], qty("80", "MiB"), [*$M_6$*], qty("185", "MiB"),
  ),
  caption: [
    Processes and memory partitions, labeled by their order of arrival (lower is
    earlier)
  ],
)<table:9.13>

Here's how each algorithm would place each process:

#grid(
  align: center + bottom,
  columns: 3,
  [#figure(
    $
      P_1 & -> M_4 \
      P_2 & -> M_1 \
      P_3 & -> M_5 \
      P_4 & -> M_2 \
      P_5 & -> M_6 \
      M_6 & -> nothing
    $,
    caption: [_First-fit_ algorithm],
  )<figure:9.13:first-fit>],
  [#figure(
    $
      P_1 & -> M_4 \
      P_2 & -> M_3 \
      P_3 & -> M_6 \
      P_4 & -> M_1 \
      P_5 & -> M_5 \
      P_6 & -> M_2 \
    $,
    caption: [_Best-fit_ algorithm],
  )<figure:9.13:best-fit>],
  [#figure(
    $
      P_1 & -> M_5 \
      P_2 & -> M_4 \
      P_3 & -> M_6 \
      P_4 & -> M_2 \
      P_5 & -> nothing
    $,
    caption: [_Worst-fit_ algorithm],
  )<figure:9.13:worst-fit>],
),

The only algorithm that was able to satisfy all requests was
@figure:9.13:best-fit. @figure:9.13:first-fit performs the fastest because it
only searches up to the first memory partition that is able to fit the process,
whilst _worst-fit_ and _best-fit_ iterate throughout the whole partition to find
the appropriate memory partition to fit into.

#pagebreak()
#problem("9.14")[
  Most systems allow a program to allocate more memory to its address space
  during execution. Allocation of data in the heap segments of programs is an
  example of such allocated memory. What is required to support dynamic memory
  allocation in the following schemes?

  + Contiguous memory allocation
  + Paging
]

For the continuous memory allocation scheme, the system needs to find a memory
block large enough to satisfy the request. If there isn't one large enough, then
the system will need to perform compaction in order to find the space to
complete the request@os-concepts[Sec. 9.2.3].

For the paging scheme, the kernel just needs to keep track of the available
frames, select it, and update the requesting process's page table.

#problem("9.15")[
  Compare the memory organization schemes of contiguous memory allocation and
  paging with respect to the following issues:

  + External fragmentation
  + Internal fragmentation
  + Ability to share code across processes
]

/ External fragmentation: When there is not enough total memory space to satisfy
  a request, but the available spaces are not contiguous
/ Internal fragmentation: Unused memory that is internal to a partition

Contiguous memory allocation scheme usually suffers from *external
fragmentation*; usually as the system keeps allocating memory, there will be
holes in non-contiguous spots. This leads to situations where a process isn't
unable to be allocated memory to until compaction occurs, which is a costly
process@os-concepts[Sec. 9.2.3]. However, this allocation scheme does not have
to deal with *internal fragmentation* as the scheme will allocate the (almost)
exact amount required by a process. Additionally, this scheme makes code-sharing
difficult since multiple processes would need to have that piece of code within
their block of memory.

The paging scheme doesn't have to deal with *external fragmentation*, as the
kernel may use any available frame for any process page. However, it struggles
with *internal fragmentation* as memory is allocated in fixed units---the last
frame of a process is usually partially filled that can't be used by other
processes. This scheme also allows for ease of code sharing, as many processes
can just map to a piece of shared code into their page table, saving a
significant amount of memory.

#problem("9.16")[
  On a system with paging, a process cannot access memory that it does not own.
  Why? How could the operating system allow access to additional memory? Why
  should it or should it not?
]

In a system with paging, a process cannot access memory that it does not own
because it only sees its own _page table_, which contains entries for pages
assigned to that process@os-concepts[Sec. 9.3.1]. There are three ways that the
operating system allows access to additional memory:

+ Dynamic allocation, where the kernel can find a free frame to allocate
  additional memory to the process,
+ Shared pages, where the process maps read-only code into their page table

#problem("9.17")[
  Explain why mobile operating systems such as iOS and Android do not support
  swapping.
]

Mobile operating systems do not support swapping because they typically use
flash memory@os-concepts[Sec. 9.5.3]. Flash memory has a limited number of
writes before it becomes unreliable, so having swap would deteriorate the
memory's lifespan quicker.

#problem("9.18")[
  Although Android does not support swapping on its boot disk, it is possible to
  set up a swap space using a separate SD nonvolatile memory card. Why would
  Android disallow swapping on its boot disk yet allow it on a secondary disk?
]

Android would allow swapping on a secondary disk as it...
+ has a longer lifespan than flash memory (i.e. more writes)
+ can be replaced once the SD card is no longer usable

#pagebreak()
#problem("9.21")[
  Assuming a #qty("1", "KiB") page size, what are the page numbers and offsets
  for the following address references (provided as decimal numbers)?

  #enum(..problem-data.at("9.21").addresses.map(address => str(address)))
]

Following the same process from @problem:9.7 gives us the below answers:

#figure(
  table(
    columns: 3,
    align: (_, y) => if y == 0 { center } else { left } + horizon,
    table.header([*Address Reference*], [*Page Number*], [*Offset*]),
    ..problem-data
      .at("9.21")
      .addresses
      .map(address => {
        let page = calc.quo(address, problem-data.at("9.21").page-size)
        let offset = address - page * problem-data.at("9.21").page-size

        ([#address], [#page], [#offset])
      })
      .flatten(),
  ),
)

#problem("9.22")[
  The MPV operating system is designed for embedded systems and has a 24-bit
  virtual address, a 20-bit physical address, and a #qty("4", "KiB") page size.
  How many entries are there in each of the following?

  + A conventional, single-level page table

  What is the maximum amount of physical memory in the MPV operating system?
]

This is similar to @problem:9.8 and @problem:9.10:

There are $2^24-qty("4", "KiB")=qty("4", "KiB")$ entires in a conventional,
single-level page table. The maximum amount of physical memory in the operating
system is $2^20$ bytes, or #qty("1", "MiB") of memory

#pagebreak()
#problem("9.23")[
  Consider a logical address space of 2,048 pages with a #qty("4", "KiB") page
  size, mapped onto a physical memory of 512 frames.

  + How many bits are required in the logical address?
  + How many bits are required in the physical address?
]

This is the same type of problem as @problem:9.4 and @problem:9.9:

$
   n_"logical" & = log_2(qty("4", "KiB"))+log_2(2048) && = 23 \
  n_"physical" & = log_2(qty("4", "KiB"))+log_2(512)  && = 21
$

#problem("9.24")[
  Consider a computer system with a 32-bit logical address and #qty("8", "KiB")
  page size. The system supports up to #qty("1", "GiB") of physical memory. How
  many entries are there in each or the following?

  + A conventional, single-level page table
]

This is a similar problem to @problem:9.8, @problem:9.10, and @problem:9.22:

There are $32-log_2(qty("8", "KiB"))-> 2^19=qty("512", "KiB")$ of entries in the
system.

#problem("9.25")[
  Consider a paging system with the page table stored in memory.

  + If a memory reference takes #qty("50", "ns"), how long does a paged memory
    reference take?
  + If we add TLBs, and if #qty("75", "%") of all page-table references are
    found in the TLBs, what is the effective memory reference time? (Assume that
    finding a pagetable entry in the TLBs takes #qty("2", "ns"), if the entry is
    present.)
]

The duration of a paged-memory reference, given a memory reference taking #qty(
  "50",
  "ns",
), is #qty("100", "ns"), as two memory accesses are required: one for accessing
frame number, and the other for accessing the actual data.

If TLBs are added, then the effective memory reference time would be
$qty("75", "%") times (qty("50", "ns")+qty("2", "ns")) + qty("25", "%") times (2 times qty("50", "ns") + qty("2", "ns")) = qty("64.5", "ns")$

#pagebreak()
#counter(heading).step()
#bibliography("../references.yaml")
