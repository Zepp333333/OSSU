// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// Pseudo code
// LOOP 
//    addr = SCREEN
//    i = 0 
//    if KBD = 0
//         LOOP2
//             if i > 8191
//                 goto ENDSUB
//             RAM[addr] = -1
//             addr = addr + 1
//             i = i+1
//             goto LOOP2
        
//         ENDLOOP2
//             goto LOOP
   
//     if KBD <> 0
//         LOOP3
//             if i > 8191
//                 goto ENDSUB
//             RAM[addr] = -1
//             addr = addr + 1
//             i = i+1
//             goto LOOP3
        
//     ENDSUB
//         goto LOOP

// Pseudo code2
// 

// addr = SCREEN
// LOOP 
//     if addr > 8191
//     goto RESET          
//     if KBD = 0
//         RAM[addr] = 0
//     if KBD <> 1
//         RAM[addr] = -1
//     addr++
//     goto LOOP
// RESET
//   addr = SCREEN
//   goto LOOP



@SCREEN
D=A 
@addr
M=D         // addr = SCREEN[0]
@24576
D=A
@last
M=D

(LOOP)
    @addr
    D=M 
    @last
    D=D-M
    @RESET
    D;JEQ   // if addr > SCREEN+8191 goto reset

    @KBD
    D=M 
    @PAINT_BLACK
    D;JNE   // if key pressed (KBD <> 0) goto PAINT_BLACK

    @KBD
    D=M    
    @PAINT_WHITE
    D;JEQ   // if key pressed (KBD <> 0) goto PAINT_BLACK


    (PAINT_WHITE)
        @addr
        A=M
        M=0     // paint white
        @INCR
        0;JMP

    (PAINT_BLACK)
        @addr
        A=M
        M=-1    // paint black
        @INCR
        0;JMP

    (RESET)
        @SCREEN
        D=A 
        @addr
        M=D         // addr = SCREEN[0]
        @LOOP
        0;JMP
    
    (INCR)
        @addr
        M=M+1       // increment addr and loop
        @LOOP
        0;JMP

    








