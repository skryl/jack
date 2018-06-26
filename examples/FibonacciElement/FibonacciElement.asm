  // set SP to 256

  @256
  D=A
  @SP
  M=D

  // call subroutine Sys.init[0]
  //


  // push Sys.init.return.0 to stack
  //

  @Sys.init.return.0
  D=A

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @LCL to stack
  //

  @LCL
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @ARG to stack
  //

  @ARG
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THIS to stack
  //

  @THIS
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THAT to stack
  //

  @THAT
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  @SP  // LCL=SP
  D=M
  @LCL
  M=D

  @SP  // ARG = SP-args-5
  D=M
  @5
  D=D-A
  @0
  D=D-A
  @ARG
  M=D

  @Sys.init  // goto
  0;JMP

  (Sys.init.return.0)  // label for return address

  // define subroutine Main.fibonacci[0]
  //

  (Main.fibonacci)

  // push ARG[0] to stack
  //

  @0
  D=A
  @ARG
  A=M+D
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push 2 to stack
  //

  @2
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

  // compare values in R12 and R13 and place
  // boolean result in R12
  //

  @R12
  D=M

  @R13
  D=M-D

  @TRUE.4
  D;JLT
  D=0
  @END.4
  0;JMP
  (TRUE.4)
  D=-1
  (END.4)

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

  // conditional jump to label
  //

  @SP
  M=M-1
  A=M
  D=M

  @IF_TRUE
  D;JNE

  // jump to label
  //

  @IF_FALSE
  0;JMP

  // create label
  //

  (IF_TRUE)

  // push ARG[0] to stack
  //

  @0
  D=A
  @ARG
  A=M+D
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // return from subroutine
  //

  @LCL   // FRAME=LCL
  D=M
  @R12
  M=D

  // copy @R12[offset] to @R13
  //

  @R12
  D=M
  @5
  A=D-A
  D=M
  @R13
  M=D

  // pop value from stack into *ARG
  //

  @SP
  M=M-1
  A=M
  D=M

  @ARG
  A=M
  M=D

  @ARG   // SP=ARG+1
  D=M
  @SP
  M=D+1

  // copy @R12[offset] to @LCL
  //

  @R12
  D=M
  @4
  A=D-A
  D=M
  @LCL
  M=D

  // copy @R12[offset] to @ARG
  //

  @R12
  D=M
  @3
  A=D-A
  D=M
  @ARG
  M=D

  // copy @R12[offset] to @THIS
  //

  @R12
  D=M
  @2
  A=D-A
  D=M
  @THIS
  M=D

  // copy @R12[offset] to @THAT
  //

  @R12
  D=M
  @1
  A=D-A
  D=M
  @THAT
  M=D

  @R13 // goto RET
  A=M
  0;JMP

  // create label
  //

  (IF_FALSE)

  // push ARG[0] to stack
  //

  @0
  D=A
  @ARG
  A=M+D
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push 2 to stack
  //

  @2
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

  // sub values in temp registers R12 and R13
  // and put result into R12
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

  // call subroutine Main.fibonacci[1]
  //


  // push Main.fibonacci.return.14 to stack
  //

  @Main.fibonacci.return.14
  D=A

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @LCL to stack
  //

  @LCL
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @ARG to stack
  //

  @ARG
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THIS to stack
  //

  @THIS
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THAT to stack
  //

  @THAT
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  @SP  // LCL=SP
  D=M
  @LCL
  M=D

  @SP  // ARG = SP-args-5
  D=M
  @5
  D=D-A
  @1
  D=D-A
  @ARG
  M=D

  @Main.fibonacci  // goto
  0;JMP

  (Main.fibonacci.return.14)  // label for return address

  // push ARG[0] to stack
  //

  @0
  D=A
  @ARG
  A=M+D
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push 1 to stack
  //

  @1
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

  // sub values in temp registers R12 and R13
  // and put result into R12
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

  // call subroutine Main.fibonacci[1]
  //


  // push Main.fibonacci.return.18 to stack
  //

  @Main.fibonacci.return.18
  D=A

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @LCL to stack
  //

  @LCL
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @ARG to stack
  //

  @ARG
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THIS to stack
  //

  @THIS
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THAT to stack
  //

  @THAT
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  @SP  // LCL=SP
  D=M
  @LCL
  M=D

  @SP  // ARG = SP-args-5
  D=M
  @5
  D=D-A
  @1
  D=D-A
  @ARG
  M=D

  @Main.fibonacci  // goto
  0;JMP

  (Main.fibonacci.return.18)  // label for return address

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

  // add values in temp registers R12 and R13
  // and put result into R12
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

  // return from subroutine
  //

  @LCL   // FRAME=LCL
  D=M
  @R12
  M=D

  // copy @R12[offset] to @R13
  //

  @R12
  D=M
  @5
  A=D-A
  D=M
  @R13
  M=D

  // pop value from stack into *ARG
  //

  @SP
  M=M-1
  A=M
  D=M

  @ARG
  A=M
  M=D

  @ARG   // SP=ARG+1
  D=M
  @SP
  M=D+1

  // copy @R12[offset] to @LCL
  //

  @R12
  D=M
  @4
  A=D-A
  D=M
  @LCL
  M=D

  // copy @R12[offset] to @ARG
  //

  @R12
  D=M
  @3
  A=D-A
  D=M
  @ARG
  M=D

  // copy @R12[offset] to @THIS
  //

  @R12
  D=M
  @2
  A=D-A
  D=M
  @THIS
  M=D

  // copy @R12[offset] to @THAT
  //

  @R12
  D=M
  @1
  A=D-A
  D=M
  @THAT
  M=D

  @R13 // goto RET
  A=M
  0;JMP

  // define subroutine Sys.init[0]
  //

  (Sys.init)

  // push 4 to stack
  //

  @4
  D=A

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // call subroutine Main.fibonacci[1]
  //


  // push Main.fibonacci.return.3 to stack
  //

  @Main.fibonacci.return.3
  D=A

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @LCL to stack
  //

  @LCL
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @ARG to stack
  //

  @ARG
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THIS to stack
  //

  @THIS
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  // push @THAT to stack
  //

  @THAT
  D=M

  @SP
  A=M
  M=D

  @SP
  M=M+1

  @SP  // LCL=SP
  D=M
  @LCL
  M=D

  @SP  // ARG = SP-args-5
  D=M
  @5
  D=D-A
  @1
  D=D-A
  @ARG
  M=D

  @Main.fibonacci  // goto
  0;JMP

  (Main.fibonacci.return.3)  // label for return address

  // create label
  //

  (WHILE)

  // jump to label
  //

  @WHILE
  0;JMP
