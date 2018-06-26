defmodule Jack.Helpers.Logging do

  def log(output) do
    if Logger.level == :debug do
      case output do
        output when is_list(output) ->
          Enum.each(output, &log/1)
        output when is_binary(output) ->
          IO.puts("#{output}")
        _ ->
          IO.inspect(output)
      end
    end
    output
  end

end