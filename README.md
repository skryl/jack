# Jack Compiler

Jack is a toy, java-like, object oriented language as presented in [Nand2Tetris](https://www.nand2tetris.org).
This project is a 2 stage compiler written for the Jack language. The compiler
generates code for a stack-based virtual machine, then translates it to Hack
assembly which can be executed on the Nand2Tetris [CPU emulator](https://www.nand2tetris.org/software).

A Hack assembler is also included for completeness but is not strictly necessary
since the cpu emulator understands both assembly code and machine code.

## Usage

### Compiling Jack source code to Jack VM code

To compile a directory containing *.jack classes

``` bash
jack myProgram/
```

To compile a jack source file

``` bash
jack myProgram/Main.jack
```

To dump the token list produced by the parser

``` bash
jack -v -t MainT.xml myProgram/Main.jack
```

To dump the AST produced by the parser

``` bash
jack -v -a Main.xml myProgram/Main.jack
```

### Translating Jack VM code to Hack assembly

To compile a directory containing *.vm files

```bash
jack -o examples/FibonacciElement
```

To compile a single *.vm file

```bash
jack -o examples/BasicLoop/BasicLoop.vm
```

To specify the output filename

```bash
jack -o -f fib.asm examples/FibonacciElement
```

To dump debug info to STDOUT

```bash
jack -o -v -f fib.asm examples/FibonacciElement
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