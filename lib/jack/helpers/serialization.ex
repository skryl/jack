defmodule Jack.Helpers.Serialization do
  alias Jack.Lang.Grammar.ParseError
  alias Jack.Lang.Tokens.{Keyword, Identifier, Symbol, StringConstant, IntegerConstant}

  @tokens [Keyword, Identifier, Symbol, StringConstant, IntegerConstant]
  @tabsize 2

  def to_xml({ :error, %ParseError{} } = error, _) do
    error
  end

  def to_xml(tokens, opts) when is_list(tokens) do
    output = opts[:token_dump]

    if output do
      xml_tokens = Enum.map(tokens, &element_to_xml(&1, 0)) |> Enum.join("\n")
      xml_dump = "<tokens>\n#{xml_tokens}\n</tokens>"

      File.write!(output, xml_dump)
    end

    tokens
  end

  def to_xml(element, opts) when is_map(element) do
    output = opts[:ast_dump]

    if output, do: File.write!(output, element_to_xml(element, 0))

    element
  end


  defp element_to_xml(elements, depth) when is_list(elements) do
    Enum.map(elements, &element_to_xml(&1, depth)) |> Enum.join("\n")
  end

  # Higher order element
  #
  defp element_to_xml(%x{} = element, depth) when x not in @tokens do
    type = to_type(x)
    pad = String.pad_leading("", depth*@tabsize)
    padi = String.pad_leading("", @tabsize)

    values = Map.to_list(element) |> Enum.map(fn({field, value}) ->
      # IO.inspect [type, field]
      if field == :__struct__ do
        ""
      else
        case value do
          val when val in [nil, []] ->
            ~s(#{pad}#{padi}<#{field} />)
          val when is_integer(val) or is_binary(val) ->
            ~s(#{pad}#{padi}<#{field}> #{element_to_xml(value, 0)} </#{field}>)
          _ ->
            ~s(#{pad}#{padi}<#{field}>\n#{element_to_xml(value, depth+2)}\n#{pad}#{padi}</#{field}>)
        end
      end
    end) |> Enum.join("\n")

    ~s(#{pad}<#{type}>#{values}\n#{pad}</#{type}>)
  end

  # Leaf token element
  #
  defp element_to_xml(%x{ value: val }, depth) when x in @tokens do
    type = to_type(x)
    pad = String.pad_leading("", depth*@tabsize)

    ~s(#{pad}<#{type}> #{sanitize(val)} </#{type}>)
  end

  # native field value
  #
  defp element_to_xml(val, depth) do
    pad = String.pad_leading("", depth*@tabsize)

    "#{pad}#{val}"
  end



  defp to_type(struct) do
    type = struct |> to_string |> String.split(".") |> List.last
    "#{String.at(type, 0) |> String.downcase}#{String.slice(type, 1..-1)}"
  end


  defp sanitize(str) do
    case str do
      "<" -> "&lt;"
      ">" -> "&gt;"
      "&" -> "&amp;"
      "\"" -> "&quot;"
      _ -> str
    end
  end


end