defmodule Jack.Lang.Parser do
  alias Jack.Lang.Tokens.{Keyword, Identifier, Symbol}
  alias Jack.Lang.Grammar.{ParseError, Class, ClassVar, Function, FunctionParameter, Var}
  alias Jack.Lang.Grammar.{LetStatement, IfStatement, WhileStatement, DoStatement, ReturnStatement}

  @statement_types ~w{let if while do return}
  @class_variable_scopes ~w{field static}
  @tokens [Keyword, Identifier, Symbol]


  def parse(tokens, class) do
    case parse_class(tokens, class) do
      {:ok, class, []} -> class
      {:ok, class, [token | rest]} ->
        { :error, %ParseError{pos: token.pos}, message: "unexpected token `#{token.value}`, expecting end of file" }
      _ = error -> error
    end
  end


  defp parse_class(tokens, class) do
    inspect_tokens("class", tokens)
    case tokens do
      [t1 | [t2 | [t3 | rest]]] ->
        case [t1, t2, t3] do
          [%Keyword{value: "class"}, %Identifier{value: name}, %Symbol{value: "{"}] ->
            case check_class_name(class, name) do
              {:ok, name} -> case parse_class_body(rest) do
                {:ok, body, rest} -> { :ok, %Class{name: name, body: body}, rest }
                _ = error -> error
              end
              _ = error -> error
            end
          _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting class"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting class"} }
    end
  end


  defp parse_class_body(tokens, body \\ []) do
    inspect_tokens("class_body", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Keyword{value: scope} when scope in @class_variable_scopes ->
            case parse_class_variables(tokens) do
              { :ok, vars, rest } -> parse_class_body(rest, vars ++ body)
              _ = error -> error
            end
          %Keyword{value: "function"} ->
            case parse_function(tokens) do
              { :ok, func, rest } -> parse_class_body(rest, [func | body])
              _ = error -> error
            end
          %Symbol{value: "}"} ->
            { :ok, Enum.reverse(body), rest }
          _ -> { :error, %ParseError{ pos: next.pos, message: "unexpected token `#{next.value}`, expecting class body"} }
        end
      _ -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting class body"} }
    end
  end


  defp parse_class_variables(tokens) do
    inspect_tokens("class_variables", tokens)
    case tokens do
      [next | rest] ->
        case parse_class_variable(tokens) do
          { :ok, var, rest } ->
            case parse_additional_class_variables(rest, var) do
              { :ok, vars, rest } -> {:ok, Enum.reverse([var | vars]), rest}
              _ = error -> error
            end
          _ = error -> error
        end
      _ -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting class variables"} }
    end
  end


  defp parse_class_variable(tokens) do
    inspect_tokens("class_variable", tokens)
    case tokens do
      [t1 | [t2 | [t3 | rest]]] ->
        case [t1, t2, t3] do
          [%Keyword{value: scope}, %t{value: type}, %Identifier{value: name}] when t in [Keyword, Identifier]->
            { :ok, %ClassVar{scope: scope, type: type, name: name}, rest }
          _ -> { :error, %ParseError{ pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting class variable"} }
        end
      _ -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting class variable"} }
    end
  end


  defp parse_additional_class_variables(tokens, prev_var, vars \\ []) do
    inspect_tokens("additional_class_variables", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Symbol{value: ","} ->
            case parse_additional_class_variable(tokens, prev_var) do
              { :ok, var, rest } -> parse_additional_class_variables(rest, prev_var, [var | vars])
              { :error, _ } = error -> error
            end
          %Symbol{value: ";"} -> { :ok, Enum.reverse(vars), rest }
          _ -> { :error, %ParseError{pos: next.pos, message: "unexpected token `#{next.value}`, expecting additional class variables"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting additional class variables"} }
    end
  end


  defp parse_additional_class_variable(tokens, prev_var) do
    inspect_tokens("additional_class_variable", tokens)
    case tokens do
      [t1 | [t2 | rest]] ->
        case [t1, t2] do
          [%Symbol{value: ","}, %Identifier{value: name}] ->
            { :ok, %ClassVar{scope: prev_var.scope, type: prev_var.type, name: name}, rest }
          _ -> { :error, %ParseError{ pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting additional class variable"} }
        end
      _ -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting additional class variable"} }
    end
  end


  defp parse_function(tokens) do
    inspect_tokens("function", tokens)
    case tokens do
      [t1 | [t2 | [t3 | [t4 | rest]]]] ->
        case [t1, t2, t3, t4] do
          [%Keyword{value: scope}, %t{value: type}, %Identifier{value: name},
           %Symbol{value: "("}] when t in [Keyword, Identifier] ->
              case parse_function_parameters(rest) do
                { :ok, parameters, rest } ->
                  case rest do
                    [t1 | rest] ->
                      case [t1] do
                        [%Symbol{value: "{"}] ->
                          case parse_function_body(rest) do
                            { :ok, body, rest } ->
                              { :ok, %Function{scope: scope, type: type, name: name, parameters: parameters, body: body}, rest }
                            _ = error -> error
                          end
                        _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting `{`"} }
                      end
                    _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting `{`"} }
                  end
                _ = error -> error
              end
          _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting function"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting function"} }
    end
  end


  defp parse_function_parameters(tokens) do
    inspect_tokens("function_parameters", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %t{value: type} when t in [Keyword, Identifier]->
            case parse_function_parameter(tokens) do
              { :ok, param, rest } ->
                case parse_additional_function_parameters(rest) do
                  {:ok, params, rest } -> { :ok, [param | params], rest}
                  _ = error -> error
                end
              _ = error -> error
            end
          %Symbol{value: ")"} -> { :ok, [], rest }
          _ -> { :error, %ParseError{pos: next.pos, message: "unexpected token `#{next.value}`, expecting function parameters"}}
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting function parameters"} }
    end
  end


  defp parse_additional_function_parameters(tokens, parameters \\ []) do
    inspect_tokens("additional_function_parameters", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Symbol{value: ","} ->
            case parse_function_parameter(rest) do
              { :ok, param, rest } -> parse_additional_function_parameters(rest, [param | parameters])
              _ = error -> error
            end
          %Symbol{value: ")"} ->
            { :ok, parameters, rest }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting additional function parameters"} }
    end
  end


  defp parse_function_parameter(tokens) do
    inspect_tokens("function_parameter", tokens)
    case tokens do
      [t1 | [t2 | rest]] ->
        case [t1, t2] do
          [%t{value: type}, %Identifier{value: name}] when t in [Keyword, Identifier] ->
            { :ok, %FunctionParameter{type: type, name: name}, rest }
          _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting function parameter"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting function parameter"} }
    end
  end


  defp parse_function_body(tokens, body \\ []) do
    inspect_tokens("function_body", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Keyword{value: "var"} ->
            case parse_variables(tokens) do
              { :ok, vars, rest } -> parse_function_body(rest, vars ++ body)
              { :error, _ } = error -> error
            end
          %Keyword{value: keyword} when keyword in @statement_types ->
            case parse_statement(tokens) do
              { :ok, statement, rest } -> parse_function_body(rest, [statement | body])
              { :error, _ } = error -> error
            end
          %Symbol{value: "}"} -> { :ok, Enum.reverse(body), rest }
          _ -> { :error, %ParseError{pos: next.pos, message: "unexptected token `#{next.value}`, expecting function body"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexptected end of file, expecting function body"} }
    end
  end


  defp parse_variables(tokens) do
    inspect_tokens("variables", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Keyword{value: "var"} ->
            case parse_variable(tokens) do
              { :ok, var, rest } ->
                case parse_additional_variables(rest, var) do
                  { :ok, vars, rest } -> { :ok, Enum.reverse([var | vars]), rest }
                  _ = error -> error
                end
              { :error, _ } = error -> error
            end
          _ -> { :error, %ParseError{pos: next.pos, message: "unexpected token `#{next.value}`, expecting variables"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting variables"} }
    end
  end


  defp parse_variable(tokens) do
    inspect_tokens("variable", tokens)
    case tokens do
      [t1 | [t2 | [t3 | rest]]] ->
        case [t1, t2, t3] do
          [%Keyword{value: "var"}, %t{value: type}, %Identifier{value: name}] when t in [Keyword, Identifier] ->
            { :ok, %Var{type: type, name: name}, rest }
          _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting variable"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting variable"} }
    end
  end


  defp parse_additional_variables(tokens, prev_var, vars \\ []) do
    inspect_tokens("additional_variables", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Symbol{value: ","} ->
            case parse_additional_variable(tokens, prev_var) do
              { :ok, var, rest } -> parse_additional_variables(rest, prev_var, [var | vars])
              { :error, _ } = error -> error
            end
          %Symbol{value: ";"} -> { :ok, Enum.reverse(vars), rest }
          _ -> { :error, %ParseError{pos: next.pos, message: "unexpected token `#{next.value}`, expecting additional variables"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting additional variables"} }
    end
  end


  defp parse_additional_variable(tokens, prev_var) do
    inspect_tokens("additional_variable", tokens)
    case tokens do
      [t1 | [t2 | rest]] ->
        case [t1, t2] do
          [%Symbol{value: ","}, %Identifier{value: name}] ->
            { :ok, %Var{type: prev_var.type, name: name}, rest }
          _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting variable"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting variable"} }
    end
  end


  defp parse_statement(tokens, statements \\ []) do
    inspect_tokens("statements", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Keyword{value: "let"}    -> parse_let_statement(tokens)
          %Keyword{value: "if"}     -> parse_if_statement(tokens)
          %Keyword{value: "while"}  -> parse_while_statement(tokens)
          %Keyword{value: "do"}     -> parse_do_statement(tokens)
          %Keyword{value: "return"} -> parse_return_statement(tokens)
          _ -> {:error, %ParseError{pos: next.pos, message: "unexpected token #{next.value}, expecting statement"}}
        end
      _ -> {:error, %ParseError{pos: nil, message: "unexpected end of file, expecting statement"}}
    end
  end


  defp parse_let_statement(tokens) do
    inspect_tokens("let_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | [t4 | [t5 | rest]]]]] ->
        case [t1, t2, t3, t4, t5] do
          [%Keyword{value: "let"}, %Identifier{value: name}, %Symbol{value: "="}, %x{} = expr, %Symbol{value: ";"}] ->
            { :ok, %LetStatement{name: name, value: expr}, rest }
          _ -> {:error, %ParseError{pos: t1.pos, message: "unexpected token #{t1.value}, expecting let statement"}}
        end
      _ -> {:error, %ParseError{pos: nil, message: "unexpected end of file, expecting let statement"}}
    end
  end


  defp parse_if_statement(tokens) do
    inspect_tokens("if_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | [t4 | [t5 | rest]]]]] ->
        case [t1, t2, t3, t4, t5] do
          [%Keyword{value: "if"}, %Symbol{value: "("}, %x{} = expr, %Symbol{value: ")"}, %Symbol{value: "{"}] ->
            case parse_statement_body(rest) do
              { :ok, if_body, rest } ->
                case rest do
                  [%Keyword{value: "else"} = t1 | [%Symbol{value: "{"} = t2 | rest]] ->
                    case parse_statement_body(rest) do
                      { :ok, else_body, rest } ->
                        { :ok, %IfStatement{condition: expr, if_body: if_body, else_body: else_body}, rest }
                      _ = error -> error
                    end
                  _ -> { :ok, %IfStatement{condition: expr, if_body: if_body}, rest }
                end
              _ = error -> error
            end
          _ -> {:error, %ParseError{pos: t1.pos, message: "unexpected token #{t1.value}, expecting if statement"}}
        end
      _ -> {:error, %ParseError{pos: nil, message: "unexpected end of file, expecting if statement"}}
    end
  end


  defp parse_while_statement(tokens) do
    inspect_tokens("while_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | [t4 | [t5 | rest]]]]] ->
        case [t1, t2, t3, t4, t5] do
          [%Keyword{value: "while"}, %Symbol{value: "("}, %x{} = expr, %Symbol{value: ")"}, %Symbol{value: "{"}] ->
            case parse_statement_body(rest) do
              { :ok, body, rest } -> {:ok, %WhileStatement{condition: expr, body: body}, rest }
              _ = error -> error
            end
          _ -> {:error, %ParseError{pos: t1.pos, message: "unexpected token #{t1.value}, expecting while statement"}}
        end
      _ -> {:error, %ParseError{pos: nil, message: "unexpected end of file, expecting while statement"}}
    end
  end


  defp parse_do_statement(tokens) do
    inspect_tokens("do_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | rest]]] ->
        case [t1, t2, t3] do
          [%Keyword{value: "do"}, %x{} = expr, %Symbol{value: ";"}] ->
            { :ok, %DoStatement{call: expr}, rest }
          _ -> {:error, %ParseError{pos: t1.pos, message: "unexpected token #{t1.value}, expecting do statement"}}
        end
      _ -> {:error, %ParseError{pos: nil, message: "unexpected end of file, expecting do statement"}}
    end
  end


  defp parse_return_statement(tokens) do
    inspect_tokens("return_statement", tokens)
    case tokens do
      [t1 | [t2 | rest]] ->
        case [t1, t2] do
          [%Keyword{value: "return"}, %Symbol{value: ";"}] ->
            { :ok, %ReturnStatement{}, rest }
          _ -> {:error, %ParseError{pos: t1.pos, message: "unexpected token #{t1.value}, expecting return statement"}}
        end
      _ -> {:error, %ParseError{pos: nil, message: "unexpected end of file, expecting return statement"}}
    end
  end


  defp parse_statement_body(tokens, body \\ []) do
    inspect_tokens("statement_body", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Keyword{value: keyword} when keyword in @statement_types ->
            case parse_statement(tokens) do
              { :ok, statement, rest } -> parse_statement_body(rest, [statement | body])
              { :error, _ } = error -> error
            end
          %Symbol{value: "}"} -> { :ok, Enum.reverse(body), rest }
          _ -> { :error, %ParseError{pos: next.pos, message: "unexptected token `#{next.value}`, expecting statement body"} }
        end
      _ -> { :error, %ParseError{pos: nil, message: "unexptected end of file, expecting statement body"} }
    end
  end


  defp check_class_name(name, id_name) do
    if name == id_name, do: {:ok, name}, else: { :error, %ParseError{} }
  end


  defp inspect_tokens(name, tokens) do
    IO.puts name
    IO.puts Enum.map(tokens, &(&1.value)) |> Enum.join(", ")
    IO.puts "\n"
  end

end