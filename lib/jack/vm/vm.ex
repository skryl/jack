defmodule Jack.VM do
  alias Jack.VM.Streamer
  alias Jack.VM.Parser
  alias Jack.VM.Codegen
  alias Jack.VM.Bundler


  def compile(path, opts) do
    Streamer.map(path, fn({_, class, code}) ->
      code |> log
           |> Parser.parse(class)
           |> log
           |> Codegen.to_asm
           |> log
    end) |> Bundler.bundle(path, opts)
  end


  defp log(output) do
    if Logger.level == :debug do
      if is_binary(output) do
        IO.puts("\n#{output}\n")
      else
        IO.inspect(output)
      end
    end
    output
  end

end