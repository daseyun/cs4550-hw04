defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  # tag token along with its rank.
  def tag_tokens(text) do
    Enum.map(text, fn x ->
      case x do
        "+" -> {:op, "+", 0}
        "-" -> {:op, "-", 0}
        "*" -> {:op, "*", 1}
        "/" -> {:op, "/", 1}
        _ -> {:num, parse_float(x), -1}
      end
    end)
  end

  # simple case. finished iteration.
  def infix_to_postfix([], postfix, stack) do
    postfix ++ stack
  end

  # https://www.free-online-calculator-use.com/infix-to-postfix-converter.html
  # link shows how to evaluate infix to postfix
  # recursion based on cases -> exit to postfix ++ stack
  def infix_to_postfix(infix, postfix \\ [], stack \\ []) do
    [head | infix_rest] = infix

    case {head, stack} do
      # nums case
      # add number to postfix
      {{:num, _, _}, _} ->
        infix_to_postfix(infix_rest, postfix ++ [head], stack)

      # ops case
      # stack is empty. put op to stack
      {{:op, _, _}, []} ->
        infix_to_postfix(infix_rest, postfix, [head])

      # stack is not empty
      {{:op, _, rank}, [stack_hd | stack_tl]} ->
        {:op, _, old_rank} = stack_hd
        # old operand is higher or equal. put top of stack to postfix. put head to stack.
        # old operand is lower. put head to stack
        if old_rank >= rank do
          infix_to_postfix(infix_rest, postfix ++ [stack_hd], [head | stack_tl])
        else
          infix_to_postfix(infix_rest, postfix, [head | stack])
        end
    end
  end

  # simple case. finished iterating expression.
  def evaluate([], stack) do
    hd(stack)
  end

  # link shows how to evaluate postfix
  # https://www.free-online-calculator-use.com/postfix-evaluator.html
  # evaluate postfix expression
  def evaluate(expr, stack \\ []) do
    [head | expr_rest] = expr

    case {head, stack} do
      # found an operand , push to stack
      {{:num, num, _}, _} ->
        evaluate(expr_rest, [num | stack])

      # found an operator, pop two operands.
      {{:op, op, _}, [x | [y | tail]]} ->
        case op do
          "+" -> evaluate(expr_rest, [y + x | tail])
          "-" -> evaluate(expr_rest, [y - x | tail])
          "*" -> evaluate(expr_rest, [y * x | tail])
          "/" -> evaluate(expr_rest, [y / x | tail])
        end
    end
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    # strips beginning and ending whitespaces.
    |> String.trim()
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> infix_to_postfix
    |> evaluate

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
