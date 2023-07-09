// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
//
// This program only needs to handle arguments that satisfy
// R0 >= 0, R1 >= 0, and R0*R1 < 32768.

// Put your code here.

// put 3 to R0
@3
D=A
@R0
M=D

// put 4 to R1
@4
D=A
@R1
M=D


@R0 // select R0
D=M // put it do D

@R1 // select R1
D=D+M // add it to what's already in D

@R2 // select R2
M=D // put from data to memory at R2

