defmodule Jack.VM.MemoryCommand do
  defstruct name: nil, segment: nil, index: 0, class: nil, line: nil
  import Jack.VM.ASM

  def push(seg, offset, pointer, indirect) do
    offset = """
      // push #{seg}[#{offset}] to stack
      //

      @#{offset}
      D=A
    """

    mem_load = """
      @#{pointer}
      A=#{indirect && "M" || "A"}+D
      D=M
    """

    push_stack = """
      @SP
      A=M
      M=D

      @SP
      M=M+1
    """

    asm = offset <> (if seg != :constant, do: mem_load, else: "") <> push_stack

    [asm]
  end


  def pop(seg, offset, pointer, indirect) do
    asm = """
      // pop value from stack into #{seg}[#{offset}]
      //

      @#{offset}
      D=A
      @#{pointer}
      D=#{indirect && "M" || "A"}+D
      @R#{tempRegister}
      M=D

      @SP
      M=M-1
      A=M
      D=M

      @R#{tempRegister}
      A=M
      M=D
    """

    [asm]
  end

end


defimpl Jack.VM.Command, for: Jack.VM.MemoryCommand do
  import Jack.VM.MemoryCommand

  @segment_map %{ constant: "0",
                  pointer:  "3",
                  temp:     "5",
                  local:    "LCL",
                  argument: "ARG",
                  this:     "THIS",
                  that:     "THAT" }


  def to_asm(%Jack.VM.MemoryCommand{ name: cmd, segment: seg, index: idx, class: class}) do
    pointer = @segment_map[seg]
    indirect = try do String.to_integer(pointer) && false rescue _ -> true end

    case { cmd, seg } do
      { :push, :static } -> push(seg, 0, "#{class}.#{idx}", false)
      { :pop, :static }  -> pop(seg, 0, "#{class}.#{idx}", false)
      { :push, _ }       -> push(seg, idx, pointer, indirect)
      { :pop, _ }        -> pop(seg, idx, pointer, indirect)
    end
  end
end