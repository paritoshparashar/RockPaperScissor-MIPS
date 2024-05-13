# Rock Paper Scissors in Assembly

## Overview

In this project, we will implement the game rock paper scissors. Our implementation differs from the traditional
two player game in the fact that the computer will play against itself. To do this, we will randomly generate
moves for both players, compare their selections and announce the winner!

## Generating Random Numbers

To generate pseudorandom numbers, the computer starts with an initial configuration, called the seed, algorithmically generating a chaotic sequence of numbers. Due to the deterministic nature of the random number generator, given the same seed twice, the algorithm will produce the same sequence of numbers twice. We will use known seed values to make our random programs reproducible.

### Configuration

Our MIPS program’s behaviour will be determined by the program configuration, which is a sequence of values
in memory. Starting from some address conf, the relevant values in memory are always at fixed locations relative
to conf. The following table uses the offset(address) notation which specifies the memory address offset
bytes after address.

| Name             | eca       | tape      | tape_len  | rule      | skip      | column    |
|------------------|-----------|-----------|-----------|-----------|-----------|-----------|
| Size             | (4 bytes) | (4 bytes) | (1 byte)  | (1 byte)  | (1 byte)  | (1 byte)  |
| Memory Address   | conf      | 4(conf)   | 8(conf)   | 9(conf)   | 10(conf)  | 11(conf)  |


## Celluar Automata
Cellular automata, such as *Conway’s Game of Life*, are computational models consisting of a collection of *cells*
and a *transition rule*. Each cell can be in one of several states and its state can be updated by applying the
transition rule simulatenously to all cells. We call the state of all cells a generation and we transform one
generation of cells to the next by applying the rule to all cells.
For example, in Conway’s Game of Life, the cells are arranged on an infinite 2-dimensional board. Each cell can
be either *live* or *dead*. The transition rule describes whether a cell will be live or dead in the next generation,
depending on the number of live cells bordering any of the four sides of the cell, and whether the cell in question
started live or dead.


## Random Numbers in MIPS ( src/random.s file )

The MARS simulator supports several syscalls related to random number generation. Each syscall related
to random number generators receives as first argument a number uniquely determining the random number
generator to use. Throughout this project, will always use the random number generator with i.d. 0. Figure 1
shows an excerpt of the MARS documentation (accessed by pressing F1 in the simulator).
Your task is to implement two functions gen_bit and gen_byte. Assume in both of these functions that the
random number generator’s seed has already been set, e.g. by the .main program.

> [**random.s**](https://github.com/paritoshparashar/RockPaperScissor-MIPS/blob/main/src/random.s) implement two functions gen_bit and gen_byte. `if (eca != 0)`, we use the ECA to generate a
random bit. To do this, we read the values skip and column from the configuration struct, simulate the automatonskip times and return the bit in the columnth column of the tape.


