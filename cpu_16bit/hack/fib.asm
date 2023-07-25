// fibonacci
//a=1
//b=1
//t=0

//for _ in range(10):
//    t=a + b
//    b=a
//    a=t
//    print(a)

// a=1
@a
M=1

// b=1
@b
M=1

// t=0
@t
M=0


(LOOP)
// display a by putting it into SCREEN
@a
D=M
@SCREEN
M=D

// [calculate a+b]
// select a
@a
// put a in D
D=M
// select b
@b
// add it to what's in D
D=D+M

// t=a+b
@t
M=D

// [b=a]
@a
D=M
@b
M=D

// [a=t]
@t
D=M
@a
M=D

@LOOP
0;JMP





