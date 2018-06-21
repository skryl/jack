# Jack Compiler

Jack is a toy java-like object oriented language as presented in Nand2Tetris.
This project is a 2 stage compiler written for the Jack language.

## Usage

### Compiling Jack source code to Jack VM code

TODO

### Compiling Jack VM code to Hack assembly

```bash
jack -v /path/to/project
```

### Assembling Hack assembly to machine code

TODO

## Building

To build the jack compiler from source

```bash
mix escript.build
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `jack` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:jack, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/jack](https://hexdocs.pm/jack).