defmodule Jack.Helpers.Fs do

  def map(path, wildcard, fun) do
    paths = if File.dir?(path), do: Path.wildcard("#{path}/#{wildcard}"), else: [path]

    Enum.map paths, fn(path) ->
      fun.({ path, classname(path), File.read!(path) })
    end
  end


  defp classname(path) do
    basename = Path.basename(path)
    extname  = Path.extname(path)
    String.replace(basename, extname, "")
  end

end