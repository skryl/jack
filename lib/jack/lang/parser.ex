defmodule Jack.Lang.Parser do
  alias Jack.Lang.Tokens.{Keyword, Identifier, Symbol}
  alias Jack.Lang.Grammar.{ParseError, Class, ClassVar, Function, FunctionParameter, Var}
  alias Jack.Lang.Grammar.{LetStatement, IfStatement, WhileStatement, DoStatement, ReturnStatement}

  @statement_types ~w{let if while do return}
  @class_variable_scopes ~w{field static}


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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting class"} }
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
      [] ->
        { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting class body"} }
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
        [] -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting class variables"} }
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
      [] -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting class variable"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting additional class variables"} }
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
      [] -> { :error, %ParseError{ pos: nil, message: "unexpected end of file, expecting additional class variable"} }
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
                { :ok, parameters, rest } -> case parse_function_body(rest) do
                  { :ok, body, rest } ->
                    { :ok, %Function{scope: scope, type: type, name: name, parameters: parameters, body: body}, rest }
                  _ = error -> error
                end
                _ = error -> error
              end
          _ -> { :error, %ParseError{pos: t1.pos, message: "unexpected token `#{t1.value}`, expecting function"} }
        end
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting function"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting function parameters"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting additional function parameters"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting function parameter"} }
    end
  end


  defp parse_function_body(tokens, body \\ []) do
    inspect_tokens("function_body", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Symbol{value: "{"} -> parse_function_body(rest, body)
          %Keyword{value: "var"} ->
            case parse_variables(tokens) do
              { :ok, vars, rest } -> parse_function_body(rest, vars ++ body)
              { :error, _ } = error -> error
            end
          %Keyword{value: keyword} when keyword in @statement_types ->
            case parse_statements(tokens) do
              { :ok, statements, rest } -> parse_function_body(rest, statements ++ body)
              { :error, _ } = error -> error
            end
          %Symbol{value: "}"} -> { :ok, Enum.reverse(body), rest }
          _ -> { :error, %ParseError{pos: next.pos, message: "unexptected token `#{next.value}`, expecting function body"} }
        end
      [] -> { :error, %ParseError{pos: nil, message: "unexptected end of file, expecting function body"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting variables"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting variable"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting additional variables"} }
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
      [] -> { :error, %ParseError{pos: nil, message: "unexpected end of file, expecting variable"} }
    end
  end


  defp parse_statements(tokens, statements \\ []) do
    inspect_tokens("statements", tokens)
    case tokens do
      [next | rest] ->
        case next do
          %Keyword{value: "let"} ->
            case parse_let_statement(tokens) do
              { :ok, statement, rest } -> parse_statements(rest, [statement | statements])
              { :error, _ } = error -> error
            end
          %Keyword{value: "if"} ->
            case parse_if_statement(tokens) do
              { :ok, statement, rest } -> parse_statements(rest, [statement | statements])
              { :error, _ } = error -> error
            end
          %Keyword{value: "while"} ->
            case parse_while_statement(tokens) do
              { :ok, statement, rest } -> parse_statements(rest, [statement | statements])
              { :error, _ } = error -> error
            end
          %Keyword{value: "do"} ->
            case parse_do_statement(tokens) do
              { :ok, statement, rest } -> parse_statements(rest, [statement | statements])
              { :error, _ } = error -> error
            end
          %Keyword{value: "return"} ->
            case parse_return_statement(tokens) do
              { :ok, statement, rest } -> parse_statements(rest, [statement | statements])
              { :error, _ } = error -> error
            end
          _ -> { :ok, statements, tokens}
        end
      [] -> { :ok, [], tokens }
    end
  end


  defp parse_let_statement(tokens) do
    inspect_tokens("let_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | [t4 | rest]]]] ->
        { :ok, %LetStatement{}, rest }
    end
  end

  defp parse_if_statement(tokens) do
    inspect_tokens("if_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | rest]]] ->
        { :ok, %IfStatement{}, rest }
    end
  end

  defp parse_while_statement(tokens) do
    inspect_tokens("while_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | rest]]] ->
        { :ok, %WhileStatement{}, rest }
    end
  end

  defp parse_do_statement(tokens) do
    inspect_tokens("do_statement", tokens)
    case tokens do
      [t1 | [t2 | [t3 | [t4 | rest]]]] ->
        { :ok, %DoStatement{}, rest }
    end
  end

  defp parse_return_statement(tokens) do
    inspect_tokens("return_statement", tokens)
    case tokens do
      [t1 | [t2 | rest]] ->
        { :ok, %ReturnStatement{}, rest }
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