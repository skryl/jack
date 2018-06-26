defmodule Jack.Helpers.Serialization do

  def to_xml(tokens, opts \\ []) when is_list(tokens) do
    output = opts[:token_dump]

    if output do
      xml_tokens = Enum.map(tokens, &token_to_xml/1) |> Enum.join("\n")
      xml_dump = "<tokens>\n#{xml_tokens}\n</tokens>"

      File.write!(output, xml_dump)
    end

    tokens
  end


  defp token_to_xml(%{ value: val, __struct__: struct } = token) when is_map(token) do
    type = to_type(struct)
    "<#{type}> #{sanitize(val)} </#{type}>"
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