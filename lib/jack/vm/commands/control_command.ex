defmodule Jack.VM.ControlCommand do
  defstruct name: nil, symbol: nil, class: nil, line: nil


  def label(sym) do
    asm = """
      // create label
      //

      (#{sym})
    """

    [asm]
  end


  def goto(sym) do
    asm = """
      // jump to label
      //

      @#{sym}
      0;JMP
    """

    [asm]
  end


  def if_goto(sym) do
    asm = """
      // conditional jump to label
      //

      @SP
      M=M-1
      A=M
      D=M

      @#{sym}
      D;JNE
    """

    [asm]
  end


end


defimpl Jack.VM.Command, for: Jack.VM.ControlCommand do
  import Jack.VM.ControlCommand

  @commands_label [:label]
  @commands_goto  [:goto]
  @commands_cond  [:"if-goto"]

  def to_asm(%{ name: name, symbol: sym }) do
    case name do
      n when n in @commands_label -> label(sym)
      n when n in @commands_goto  -> goto(sym)
      n when n in @commands_cond  -> if_goto(sym)
    end
  end
end

