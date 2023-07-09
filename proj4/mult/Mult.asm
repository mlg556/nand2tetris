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

// add R0, R1 times

// put 3 to R0
//@3
//D=A
//@R0
//M=D

// put 4 to R1
//@4
//D=A
//@R1
//M=D

// i = 1
@i
M=1

// res = 0
@res
M=0

(LOOP)
// if i > R1 becomes (i-R1) > 0
// put i to D
@i
D=M

@R1
D=D-M

@STOP
D;JGT

// if not, res += R0, i+=1
@res
D=M
@R0
D=D+M
@res
M=D

@i
M=M+1

// go to (LOOP)
@LOOP
0;JMP

(STOP)
// R2 = res
@res
D=M
@R2
M=D

// infinite loop
(END)
@END
0;JMP
