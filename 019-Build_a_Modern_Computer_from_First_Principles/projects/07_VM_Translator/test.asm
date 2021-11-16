// push constant 7
@7
D=A
@SP
A=M
M=D
@SP
M=M+1
// push temp 8
@R13
D=M
@SP
A=M
M=D
@SP
M=M+1
// add add 
@SP
M=M-1
A=M
D=M
@SP
M=M-1
@SP
A=M
M=M+D
@SP
M=M+1