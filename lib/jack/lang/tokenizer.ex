defmodule Jack.Lang.Tokenizer do
  alias Jack.Helpers.Comments
  alias Jack.Helpers.Serialization
  alias Jack.Lang.Tokens.{Keyword, Identifier, Symbol, IntegerConstant, StringConstant}

  import Jack.Helpers.Logging

  @symbols  ~w{{ \} ( ) [ ] . , ; + - * / & | < > = ~ ]}
  @keywords ~w{ class constructor function method field static var int char
                boolean void true false null this let do if else while return }

  @identifier ~r/([a-zA-Z_]\w*)(.*)/
  @symbol     ~r/(.)(.*)/
  @integer    ~r/(\d+)(.*)/
  @string     ~r/"(.*)"(.*)/
  @whitespace ~r/(\s+)(.*)/


  def tokenize(code) do
    code
      |> Comments.clean
      |> log
      |> tokenize_lines
  end


  defp tokenize_lines(lines) do
    Enum.flat_map (lines |> Enum.with_index), fn({ line, idx }) ->
      to_tokens(line, idx+1, 1) |> Enum.reverse
    end
  end


  defp to_tokens(line, lnum, cnum, tokens \\ []) do
    pos = %{ line: lnum, char: cnum }

    case line do
      "" -> tokens
      <<char::binary-size(1), str::binary>> ->
        cond do
          is_symbol?(char) ->
            { sym, len, rest } = shift_symbol(line, pos)
            to_tokens(rest, lnum, cnum + len, [sym | tokens])
          is_identifier?(char)  ->
            { id, len, rest} = shift_identifier(line, pos)
            to_tokens(rest, lnum, cnum + len, [id | tokens])
          is_integer?(char) ->
            { int, len, rest } = shift_integer(line, pos)
            to_tokens(rest, lnum, cnum + len, [int | tokens] )
          is_string?(char) ->
            { str, len, rest } = shift_string(line, pos)
            to_tokens(rest, lnum, cnum + len, [str | tokens])
          is_whitespace?(char) ->
            { blank, len, rest } = shift_whitespace(line, pos)
            to_tokens(rest, lnum, cnum + len, tokens)
        end
    end
  end


  defp is_identifier?(char) do
    String.match?(char, @identifier)
  end

  defp is_keyword?(id) do
    Enum.member?(@keywords, id)
  end

  defp is_symbol?(char) do
    Enum.member?(@symbols, char)
  end

  defp is_integer?(char) do
    String.match?(char, @integer)
  end

  defp is_string?(char) do
    char == ~s(")
  end

  defp is_whitespace?(char) do
    String.match?(char, @whitespace)
  end


  defp shift_identifier(line, pos) do
    [_, id, rest] = Regex.run(@identifier, line)
    cond do
      is_keyword?(id) -> { %Keyword{value: id, pos: pos}, String.length(id), rest}
      true -> { %Identifier{value: id, pos: pos}, String.length(id), rest }
    end
  end

  defp shift_symbol(line, pos) do
    [_, sym, rest] = Regex.run(@symbol, line)
    { %Symbol{value: sym, pos: pos}, String.length(sym), rest }
  end

  defp shift_integer(line, pos) do
    [_, int, rest] = Regex.run(@integer, line)
    { %IntegerConstant{value: int, pos: pos}, String.length(int), rest }
  end

  defp shift_string(line, pos) do
    [_, str, rest] = Regex.run(@string, line)
    { %StringConstant{value: str, pos: pos}, String.length(str), rest }
  end

  defp shift_whitespace(line, pos) do
    [_, blank, rest] = Regex.run(@whitespace, line)
    { nil, String.length(blank), rest }
  end

end