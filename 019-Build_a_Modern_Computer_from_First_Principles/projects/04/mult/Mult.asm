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

// Pseudo code
// n = R0
// i = 1
// acc = 0
// Loop:
//     if i > n goto STOP
//     acc = acc + R1
//     i = i + 1
// STOP:
//     R2 = acc


@R0
D=M
@n 
M=D     // n = R0
@i 
M=1     // i = 1
@acc
M=0     // sum = 0

(LOOP)
    @i
    D=M
    @n
    D=D-M
    @STOP
    D;JGT       //if i > n goto stop

    @acc
    D=M
    @R1
    D=D+M
    @acc
    M=D         //acc = acc + R1
    @i 
    M=M+1       //i++
    @LOOP
    0;JMP

(STOP)
    @acc
    D=M
    @R2
    M=D         //R2 = acc

(END)
    @END
    0; JMP




    
