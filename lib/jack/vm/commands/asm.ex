defmodule Jack.VM.ASM do

  def tempRegister, do: 12

  def set_sp(val) do
    asm = """
      @#{val}
      D=A
      @SP
      M=D
    """

    [asm]
  end


  def copy_mem(destination, origin, offset) do
    asm = """
      // copy @#{origin}[offset] to @#{destination}
      //

      @#{origin}
      D=M
      @#{abs(offset)}
      A=D#{offset < 0 && "-" || "+"}A
      D=M
      @#{destination}
      M=D
    """

    [asm]
  end


  def pop_temp(num) do
    asm = Enum.map Range.new(0, num-1), fn n -> """
      // pop value from stack into temp @R#{tempRegister+n}
      //

      @SP
      M=M-1
      A=M
      D=M

      @R#{tempRegister+n}
      M=D
    """
    end

    asm
  end


  def push_temp(num) do
    asm = Enum.map Range.new(0, num-1), fn n -> """
      // push temp @R#{tempRegister+n} to stack
      //

      @R#{tempRegister+n}
      D=M

      @SP
      A=M
      M=D

      @SP
      M=M+1
    """
    end

    asm
  end


  def pop_reg(reg) do
    asm = """
      // pop value from stack into *#{reg}
      //

      @SP
      M=M-1
      A=M
      D=M

      @#{reg}
      A=M
      M=D
    """

    [asm]
  end


  def push_reg(reg) do
    asm = """
      // push @#{reg} to stack
      //

      @#{reg}
      D=M

      @SP
      A=M
      M=D

      @SP
      M=M+1
    """

    [asm]
  end


  def push_val(val) do
    asm = """
      // push #{val} to stack
      //

      @#{val}
      D=A

      @SP
      A=M
      M=D

      @SP
      M=M+1
    """

    [asm]
  end


end