defmodule Jack.VM do
  alias Jack.Helpers.Fs
  alias Jack.VM.Parser
  alias Jack.VM.Codegen
  alias Jack.VM.Bundler

  import Jack.Helpers.Logging


  def compile(path, opts) do
    Fs.map(path, "*.vm", fn({_, class, code}) ->
      code |> log
           |> Parser.parse(class)
           |> log
           |> Codegen.to_asm
           |> log
    end) |> Bundler.bundle(path, opts)
  end

end