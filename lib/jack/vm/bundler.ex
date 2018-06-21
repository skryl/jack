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
    call_init = call(%VM.FunctionCommand{function: "Sys.init", args: 0, line: 0})
    bootstrap = Enum.join(set_sp(256) ++ call_init, "\n")
    List.insert_at(code_stream, 0, bootstrap)
  end


end