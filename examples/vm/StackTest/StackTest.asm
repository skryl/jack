  // push constant[17] to stack
  //

  @17
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[17] to stack
  //

  @17
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // eq values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.3
  D;JEQ
  (FALSE.3)
  D=0
  @END.3
  0;JMP
  (TRUE.3)
  D=-1
  (END.3)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[17] to stack
  //

  @17
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[16] to stack
  //

  @16
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // eq values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.6
  D;JEQ
  (FALSE.6)
  D=0
  @END.6
  0;JMP
  (TRUE.6)
  D=-1
  (END.6)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[16] to stack
  //

  @16
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[17] to stack
  //

  @17
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // eq values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.9
  D;JEQ
  (FALSE.9)
  D=0
  @END.9
  0;JMP
  (TRUE.9)
  D=-1
  (END.9)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[892] to stack
  //

  @892
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[891] to stack
  //

  @891
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // lt values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.12
  D;JLT
  (FALSE.12)
  D=0
  @END.12
  0;JMP
  (TRUE.12)
  D=-1
  (END.12)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[891] to stack
  //

  @891
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[892] to stack
  //

  @892
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // lt values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.15
  D;JLT
  (FALSE.15)
  D=0
  @END.15
  0;JMP
  (TRUE.15)
  D=-1
  (END.15)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[891] to stack
  //

  @891
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[891] to stack
  //

  @891
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // lt values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.18
  D;JLT
  (FALSE.18)
  D=0
  @END.18
  0;JMP
  (TRUE.18)
  D=-1
  (END.18)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[32767] to stack
  //

  @32767
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[32766] to stack
  //

  @32766
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // gt values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.21
  D;JGT
  (FALSE.21)
  D=0
  @END.21
  0;JMP
  (TRUE.21)
  D=-1
  (END.21)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[32766] to stack
  //

  @32766
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[32767] to stack
  //

  @32767
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // gt values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.24
  D;JGT
  (FALSE.24)
  D=0
  @END.24
  0;JMP
  (TRUE.24)
  D=-1
  (END.24)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[32766] to stack
  //

  @32766
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[32766] to stack
  //

  @32766
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // gt values in R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.27
  D;JGT
  (FALSE.27)
  D=0
  @END.27
  0;JMP
  (TRUE.27)
  D=-1
  (END.27)

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[57] to stack
  //

  @57
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[31] to stack
  //

  @31
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[53] to stack
  //

  @53
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // add values in temp registers R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M+D

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[112] to stack
  //

  @112
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // sub values in temp registers R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // neg value in R12 and put result into R12
  //

  @R12
  D=-M
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // and values in temp registers R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M&D

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push constant[82] to stack
  //

  @82
  D=A
  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // pop value from stack into temp @R13
  //

  @SP
  M=M-1
  A=M
  D=M

  @R13
  M=D

  // or values in temp registers R12 and R13 and put result into R12
  //

  @R12
  D=M

  @R13
  D=M|D

  @R12
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // pop value from stack into temp @R12
  //

  @SP
  M=M-1
  A=M
  D=M

  @R12
  M=D

  // not value in R12 and put result into R12
  //

  @R12
  D=!M
  M=D

  // push temp @R12 to stack
  //

  @R12
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1
