defmodule Jack.VM.MemoryCommand do
  defstruct name: nil, segment: nil, index: 0, class: nil, line: nil
  import Jack.VM.ASM


  def push(address, offset, indirect) do
    asm = """
      // push #{address}[#{offset}] to stack
      //

      @#{offset}
      D=A
      @#{address}
      A=#{indirect && "M" || "A"}+D
      D=M

      @SP
      A=M
      M=D

      @SP
      M=M+1
    """

    [asm]
  end


  def pop(address, offset, indirect) do
    asm = """
      // pop value from stack into #{address}[#{offset}]
      //

      @#{offset}
      D=A
      @#{address}
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
  import Jack.VM.ASM, only: [push_val: 1]

  @segment_map %{ constant: "0",
                  pointer:  "3",
                  temp:     "5",
                  local:    "LCL",
                  argument: "ARG",
                  this:     "THIS",
                  that:     "THAT" }


  def to_asm(%{ name: cmd, segment: seg, index: offset, class: class }) do
    address  = @segment_map[seg]
    indirect = try do String.to_integer(address) && false rescue _ -> true end

    case { cmd, seg } do
      { :push, :constant } -> push_val(offset)
      { :push, :static }   -> push("#{class}.#{offset}", 0, false)
      { :pop, :static }    -> pop("#{class}.#{offset}", 0, false)
      { :push, _ }         -> push(address, offset, indirect)
      { :pop, _ }          -> pop(address, offset, indirect)
    end
  end
end