# Assignment 3

## Programming

We discussed `char.c` and `block.c` programs in class. The programs copy a file from “source” to “target”.

1. Modify the programs by using only system calls to perform the task. These system calls are `open`, `read`, `write`, and `exit`. Use text files to test your programs as shown in class.
2. Find a way to show that the block transfer program is more efficient.

| Library Call | System Call |
| ------------ | ----------- |
|    `fopen`   |   `open`    |
|    `fgets`   |   `read`    |
|    `fgetc`   |   `read`    |
|    `fread`   |   `read`    |
|    `fputs`   |   `write`   |
|    `fputc`   |   `write`   |
|   `fwrite`   |   `write`   |

## Deliverables

1. Source code that can be compiled error-free
2. Executable file that runs with no problem.
3. Images that shows the result of running the program.

## How was this project built?
I compile both of the programs using the same source file. The difference is that I pass `-Dchunked` when compiling `main.c` with the chunked copying version. You can check the `Makefile` for more details.

## Building and Running my Project
You shouldn't have to worry about re-compiling my binaries, but if you need to then these dependencies are required:
- `clangd 21.1.2` with a target of `x86_64`
- `GNU Make 4.4.1`

1. Run `make all`
2. ...congrats the binaries are built! `./bin/chunked` is the copy program with chunked copying of 16 bytes, while `./bin/chars` is the copy program with copying of 1 byte at a time
3. You can use the randomly-generated files in `./tests/`. The size of the file is approximately the size listed in the filename

## Trends
The results of the chunked copying (128 bytes) vs. the copying per-character are seen in the following screenshots:

![Results of copying per-chunk of 128 bytes](./assets/chunked-results.png)

![Results of copying per-character](./assets/chars-results.png)

Below is a table comparing the ratios of the clock cycles taken to copy each file:

| File size (MB) | Copying Per-Character | Copying Per-Chunk (128 bytes) | Ratio   |
|---------------:| :-------------------- | :---------------------------- | :------ |
| 200            | 168973051             | 1234202                       | 136.909 | 
| 100            |  77511359             |  675962                       | 114.668 | 
| 50             |  39325290             |  336140                       | 116.991 | 

It looks like the ratio of the copying speeds between the per-character method and by chunk is approximately its chunk size
