defmodule Jack.VM.ArithmeticCommand do
  defstruct name: nil, class: nil, line: nil
  import Jack.VM.ASM

  def binary_op(stream, cmd, _) do
    asm_op = case cmd do
      :add -> "+"
      :sub -> "-"
      :and -> "&"
      :or  -> "|"
    end

    asm = """
      // #{cmd} values in temp registers R#{tempRegister} and R#{tempRegister+1}
      // and put result into R#{tempRegister}
      //

      @R#{tempRegister}
      D=M

      @R#{tempRegister+1}
      D=M#{asm_op}D

      @R#{tempRegister}
      M=D
    """

    stream ++ [asm]
  end


  def unary_op(stream, cmd, _) do
    asm_op = case cmd do
      :neg -> "-"
      :not -> "!"
    end

    asm = """
      // #{cmd} value in R#{tempRegister} and put result into R#{tempRegister}
      //

      @R#{tempRegister}
      D=#{asm_op}M
      M=D
    """

    stream ++ [asm]
  end


  def comp_op(stream, cmd, line) do
    asm_op = case cmd do
      :eq  -> "EQ"
      :gt  -> "GT"
      :lt  -> "LT"
    end

    asm = """
      // compare values in R#{tempRegister} and R#{tempRegister+1} and place
      // boolean result in R#{tempRegister}
      //

      @R#{tempRegister}
      D=M

      @R#{tempRegister+1}
      D=M-D

      @TRUE.#{line}
      D;J#{asm_op}
      D=0
      @END.#{line}
      0;JMP
      (TRUE.#{line})
      D=-1
      (END.#{line})

      @R#{tempRegister}
      M=D
    """

    stream ++ [asm]
  end


  def pop(stream \\ [], num) do
    stream ++ pop_temp(num)
  end


  def push(stream \\ [], num) do
    stream ++ push_temp(num)
  end

end


defimpl Jack.VM.Command, for: Jack.VM.ArithmeticCommand do
  import Jack.VM.ArithmeticCommand

  @commands_binary [:add, :sub, :and, :or]
  @commands_unary  [:neg, :not]
  @commands_comp   [:eq, :gt, :lt]

  def to_asm(%{ name: cmd, line: line }) do
    case cmd do
      n when n in @commands_binary -> pop(2) |> binary_op(cmd, line) |> push(1)
      n when n in @commands_comp   -> pop(2) |> comp_op(cmd, line)   |> push(1)
      n when n in @commands_unary  -> pop(1) |> unary_op(cmd, line)  |> push(1)
    end
  end
end