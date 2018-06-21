defmodule Jack.VM.Parser do
  require Logger
  alias Jack.VM

  @memory_commands     ["push", "pop"]
  @function_commands   ["function", "call", "return"]
  @control_commands    ["label", "goto", "if-goto"]
  @arithmetic_commands ["add", "sub", "neg", "eq", "gt", "lt", "and", "or", "not"]


  def parse(code, class) do
    code |> split |> clean |> tokenize(class)
  end

  defp split(text) do
    String.split(text, "\n")
  end

  # clear comments and empty lines
  #
  defp clean(lines) do
    lines
      |> Enum.map(&String.trim(Regex.replace(~r/\/\/.*/, &1, "")))
      |> Enum.filter(&(String.length(&1) > 0))
  end


  # convert instructions to tuples of the form { instr, arg1, arg2 }
  #
  defp tokenize(lines, class) do
    Enum.map (lines |> Enum.with_index), fn({ line, idx }) ->
      line |> String.trim
           |> String.split(" ")
           |> List.to_tuple
           |> from_tuple(class, idx+1)
    end
  end


  # convert tuples to proper types
  #
  defp from_tuple(tuple, class, line) do
    if Logger.level == :debug, do: IO.inspect(tuple)

    case tuple do
      {name, seg, idx} when name in @memory_commands ->
        %VM.MemoryCommand{
          name: String.to_atom(name), segment: String.to_atom(seg), index: idx, class: class, line: line}

      {name, fname, args} when name in @function_commands ->
        %VM.FunctionCommand{
          name: String.to_atom(name), function: fname, args: String.to_integer(args), class: class, line: line}

      {name} when name in @function_commands ->
        %VM.FunctionCommand{name: String.to_atom(name), class: class, line: line}

      {name, sym} when name in @control_commands ->
        %VM.ControlCommand{name: String.to_atom(name), symbol: sym, class: class, line: line}

      {name} when name in @arithmetic_commands ->
        %VM.ArithmeticCommand{name: String.to_atom(name), class: class, line: line}

      _ -> %VM.NoOpCommand{name: String.to_atom(elem(tuple, 0)), class: class, line: line}
    end
  end


end
