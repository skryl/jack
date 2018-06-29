defmodule Jack.Helpers.Serialization do
  alias Jack.Lang.Tokens.{Keyword, Identifier, Symbol, StringConstant, IntegerConstant}

  @tokens [Keyword, Identifier, Symbol, StringConstant, IntegerConstant]

  def to_xml(elements, opts \\ []) do
    output = opts[:token_dump]

    if output do
      xml_tokens = Enum.map(elements, &element_to_xml/1) |> Enum.join("\n")
      xml_dump = "<tokens>\n#{xml_tokens}\n</tokens>"

      File.write!(output, xml_dump)
    end

    tokens
  end


  defp element_to_xml(%x{ value: val } = token) when x in @tokens do
    type = to_type(x)
    "<#{type}> #{sanitize(val)} </#{type}>"
  end


  defp element_to_xml(%x{} = element) when x not in @tokens do
    type = to_type(x)

    """
    <#{type}>
      #{values}
    </#{type}>
    """
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