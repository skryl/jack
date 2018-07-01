defmodule Jack.Helpers.Comments do

  @line_comment ~r/\/\/.*/
  @doc_comment  ~r/\/\*\*.*?\*\//ms


  # remove comments and empty lines
  #
  def clean(text) do
    text |> remove_comments |> split |> remove_emptylines
  end


  defp split(text) do
    String.split(text, "\n")
  end


  defp remove_comments(text) do
    text
      |> String.replace(@doc_comment, "")
      |> String.replace(@line_comment, "")
  end


  defp remove_emptylines(lines) do
    for line <- lines, (line |> String.trim |> String.length > 0), do: line |> String.trim
  end

end