defmodule Jack.VM.FunctionCommand do
  defstruct name: nil, function: nil, args: 0, class: nil, line: nil
  import Jack.VM.ASM


  # function entry code simply allocates memory for its locals
  #
  #  push 0 k times
  #
  def func(function, args, _) do
    label = """
      // define subroutine #{function}[#{args}]
      //

      (#{function})
    """

    clear_locals = for n <- (0..args), n > 0, do: push_val(0)

    [label] ++ clear_locals
  end


  # function call must push its return address and all of its
  # registers to the stack before making the call
  #
  #   push return-address
  #   push LCL
  #   push ARG
  #   push THIS
  #   push THAT
  #   ARG = SP-n-5
  #   LCL = SP
  #   goto f
  # (return-address)
  #
  def call(function, args, line) do
    addresses = ["#{function}.return.#{line}"]
    registers = ["LCL", "ARG", "THIS", "THAT"]

    store_addresses = for a <- addresses, do: push_val(a)
    store_registers = for r <- registers, do: push_reg(r)

    comment = """
      // call subroutine #{function}[#{args}]
      //

    """

    call = """
      @SP  // LCL=SP
      D=M
      @LCL
      M=D

      @SP  // ARG = SP-args-5
      D=M
      @5
      D=D-A
      @#{args}
      D=D-A
      @ARG
      M=D

      @#{function}  // goto
      0;JMP

      (#{function}.return.#{line})  // label for return address
    """

    [comment] ++ store_addresses ++ store_registers ++ [call]
  end


  # return from function call must restore the callers registers
  # and push the return value on the stack
  #
  #  FRAME=LCL
  #  RET=*(FRAME-5)
  #  *ARG=pop()
  #  SP=ARG+1
  #  THAT=*(FRAME-1)
  #  THIS=*(FRAME-2)
  #  ARG=*(FRAME-3)
  #  LCL=*(FRAME-4)
  #  goto RET
  #
  def return do
    registers = [{ "LCL", 4 }, { "ARG", 3 }, { "THIS", 2 }, { "THAT", 1 }]

    frame = """
      // return from subroutine
      //

      @LCL   // FRAME=LCL
      D=M
      @R#{tempRegister}
      M=D
    """

    ret = copy_mem("R#{tempRegister+1}", "R#{tempRegister}", -5)

    pop_arg = pop_reg("ARG")

    sp = """
      @ARG   // SP=ARG+1
      D=M
      @SP
      M=D+1
    """

    restore = for { reg, offset } <- registers do
      copy_mem(reg, "R#{tempRegister}", -offset)
    end

    jump = """
      @R#{tempRegister+1} // goto RET
      A=M
      0;JMP
    """

    [frame] ++ [ret] ++ [pop_arg] ++ [sp] ++ restore ++ [jump]
  end

end


defimpl Jack.VM.Command, for: Jack.VM.FunctionCommand do
  import Jack.VM.FunctionCommand

  @commands_func   [:function]
  @commands_call   [:call]
  @commands_return [:return]

  def to_asm(%{name: name, function: function, args: args, line: line}) do
    case name do
      n when n in @commands_func   -> func(function, args, line)
      n when n in @commands_call   -> call(function, args, line)
      n when n in @commands_return -> return()
    end
  end
end