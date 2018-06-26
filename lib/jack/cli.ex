defmodule Jack.CLI do
  require Logger

  def main(argv) do
    { path, opts } = parse_args(argv)
    configure(opts)

    if opts[:vm] do
      vm_compile(path, opts)
    else
      source_compile(path, opts)
    end
  end


  def parse_args(argv) do
    optparse = OptionParser.parse(argv,
      switches: [ help:       :boolean,
                  verbose:    :boolean,
                  vm:         :boolean,
                  output:     :string,
                  ast_dump:   :string,
                  token_dump: :string],
      aliases:  [ h: :help,
                  v: :verbose,
                  m: :vm,
                  o: :output,
                  a: :ast_dump,
                  t: :token_dump ])

    Logger.debug("parse_args: #{inspect optparse}")

    case optparse do
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


  defp vm_compile(path, opts) do
    Logger.info("compiling vm path #{path}")
    filename = Jack.VM.compile(path, opts)
    Logger.info("writing output to #{filename}")
  end


  defp source_compile(path, opts) do
    Logger.info("compiling source path #{path}")
    filenames = Jack.Lang.compile(path, opts)
    # Logger.info("writing output to #{filenames}")
  end


end