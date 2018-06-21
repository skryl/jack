defmodule Jack.CLI do
  require Logger

  def main(argv) do
    { path, opts } = parse_args(argv)
    configure(opts)
    compile(path, opts)
  end


  def parse_args(argv) do
    parse = OptionParser.parse(argv,
      switches: [ help:    :boolean,
                  verbose: :boolean,
                  vm:      :boolean,
                  output:  :string],
      aliases:  [ h: :help,
                  v: :verbose,
                  m: :vm,
                  o: :output ])

    Logger.debug("parse_args: #{inspect parse}")

    case parse do
      { [ help: true ], _, _  } -> help()
      { _ = opts, [ path ], _ } -> { path, opts }
      _ -> help()
    end
  end


  defp help do
    IO.puts "usage: jack [opts] PATH"
    System.halt(0)
  end


  defp configure(opts) do
    if opts[:verbose] do
      Logger.configure(level: :debug)
    end
  end


  defp compile(path, opts) do
    Logger.info("compiling path #{path}")
    filename = Jack.VM.compile(path, opts)
    Logger.info("writing output to #{filename}")
  end


end