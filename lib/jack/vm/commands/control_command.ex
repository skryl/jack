defmodule Jack.VM.ControlCommand do
  defstruct name: nil, symbol: nil, class: nil, line: nil
  import Jack.VM.ASM

  def label(%{symbol: sym}) do
    asm = """
      // create a label
      //
      (#{sym})
    """

    [asm]
  end


  def goto(%{symbol: sym}) do
    asm = """
      // jump to label #{sym}
      //
      @#{sym}
      0;JMP
    """

    [asm]
  end


  def cond(stream, %{symbol: sym}) do
    asm = """
      // conditional jump to label #{sym}
      //
      @R#{tempRegister}
      D=M
      @#{sym}
      D;JNE
    """

    stream ++ [asm]
  end


  def pop(num) do
    [pop_temp(num)]
  end


end


defimpl Jack.VM.Command, for: Jack.VM.ControlCommand do
  import Jack.VM.ControlCommand

  @commands_label [:label]
  @commands_goto  [:goto]
  @commands_cond  [:"if-goto"]

  def to_asm(%Jack.VM.ControlCommand{ name: name } = command) do
    case name do
      n when n in @commands_label -> label(command)
      n when n in @commands_goto  -> goto(command)
      n when n in @commands_cond  -> pop(1) |> cond(command)
    end
  end
end

