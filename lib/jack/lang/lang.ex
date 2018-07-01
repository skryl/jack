defmodule Jack.Lang do
  alias Jack.Helpers.Fs
  alias Jack.Helpers.Serialization
  alias Jack.Lang.Tokenizer
  alias Jack.Lang.Parser
  alias Jack.Lang.Codegen

  import Jack.Helpers.Logging


  def compile(path, opts) do
    Fs.map path, "*.jack", fn({_, class, code}) ->
      code |> log
           |> Tokenizer.tokenize
           |> log
           |> Serialization.to_xml(opts)
           |> Parser.parse(class)
           |> log
           |> Serialization.to_xml(opts)
    end
  end

end