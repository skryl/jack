defmodule Jack.VM.Bundler do
  alias  Jack.VM
  import VM.ASM, only: [set_sp: 1]
  import VM.FunctionCommand

  def bundle(code_stream, path, opts) do
    output =
      if File.dir?(path) do
        opts[:output] || "#{path}/#{Path.basename(path)}.asm"
      else
        opts[:output] || String.replace(path, ".vm", ".asm")
      end

    final = code_stream |> bootstrap |> Enum.join("\n")
    File.write!(output, final)
    output
  end


  defp bootstrap(code_stream) do
    bootstrap = Enum.join(set_sp(256) ++ call("Sys.init", 0, 0), "\n")
    List.insert_at(code_stream, 0, bootstrap)
  end


end