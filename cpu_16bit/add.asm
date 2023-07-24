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

// select R0
@R0
// put it do D
D=M 

// select R1
@R1
// add it to what's already in D
D=D+M

// select R2
@R2
 // put from data to memory at R2
M=D

