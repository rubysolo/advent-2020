defmodule AdventOfCode.Y2020.D18 do
  @moduledoc """
  --- Day 18: Operation Order ---
  As you look out the window and notice a heavily-forested continent slowly appear over the horizon, you are
  interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

  Unfortunately, it seems like this "math" follows different rules than you remember.

  The homework (your puzzle input) consists of a series of expressions that consist of addition (+),
  multiplication (*), and parentheses ((...)). Just like normal math, parentheses indicate that the expression
  inside must be evaluated before it can be used by the surrounding expression. Addition still finds the sum of
  the numbers on both sides of the operator, and multiplication still finds the product.

  However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition,
  the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they
  appear.

  For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are as follows:

  1 + 2 * 3 + 4 * 5 + 6
    3   * 3 + 4 * 5 + 6
        9   + 4 * 5 + 6
          13   * 5 + 6
              65   + 6
                  71

  Parentheses can override this order; for example, here is what happens if parentheses are added to form
  1 + (2 * 3) + (4 * (5 + 6)):

  1 + (2 * 3) + (4 * (5 + 6))
  1 +    6    + (4 * (5 + 6))
      7      + (4 * (5 + 6))
      7      + (4 *   11   )
      7      +     44
              51
  Here are a few more examples:

  2 * 3 + (4 * 5) becomes 26.
  5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 437.
  5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 12240.
  ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.

  ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.
    ( 54        *      126       + 6) + 2 + 4 * 2
                    6810              + 2 + 4 * 2

  Before you can help with the homework, you need to understand it yourself. Evaluate the expression on each line
  of the homework; what is the sum of the resulting values?
  """
  alias AdventOfCode.Input
  @real_input Input.lines("2020/18.txt")

  def tokenize(line) do
    line
    |> space_parens()
    |> String.split(" ")
    |> Enum.map(&convert/1)
  end

  def space_parens(line) do
    # Pater dimitte illis non enim sciunt quid faciunt
    updated = Regex.replace(~r/\(\s*/, line, "( ")
    Regex.replace(~r/\s*\)/, updated, " )")
  end

  def convert("+"), do: "+"
  def convert("*"), do: "*"
  def convert("("), do: "("
  def convert(")"), do: ")"
  def convert(n), do: String.to_integer(n)

  defmodule Parser do
    @moduledoc """
    Dijkstra's shunting yard -- https://en.wikipedia.org/wiki/Shunting-yard_algorithm
    """
    @default_precedence %{"+" => 0, "*" => 1}

    @doc """
    convert a stream of integers, operators ("+" or "*"), and precedence indicators ("(" or ")")
    into RPN suitable for stack evaluation
    """
    def parse(tokens, precedence \\ @default_precedence) when is_list(tokens) do
      {_, output, ops} = parse(tokens, [], [], precedence)
      if Enum.any?(ops, & &1 == "(" || &1 == ")"), do: raise "unbalanced parens"

      Enum.reverse(output) ++ ops
    end

    def parse([], output, ops, _precedence), do: {[], output, ops}
    def parse([token | tokens], output, ops, precedence) do
      {output, ops} = parse_token(token, output, ops, precedence)
      parse(tokens, output, ops, precedence)
    end

    # move tokens into either the output queue or the operations stack
    def parse_token(n, output, ops, _precedence) when is_integer(n), do: {[n | output], ops}
    def parse_token(op, output, ops, precedence) when op in ~w( + * ), do: parse_op(op, output, ops, precedence)
    def parse_token("(", output, ops, _precedence), do: {output, ["(" | ops]}
    def parse_token(")", output, ops, _precedence), do: close(")", output, ops)

    def parse_op(op, output, ops, precedence) do
      {sub_output, sub_ops} = honor_precedence(op, [], ops, precedence)
      {sub_output ++ output, [op | sub_ops]}
    end

    def honor_precedence(_op, output, [], _precedence), do: {output, []}
    def honor_precedence(_op, output, [prev_op | _] = ops, _precedence) when prev_op in ["(", ")"], do: {output, ops}
    def honor_precedence(op, output, [prev_op | rest] = ops, precedence) do
      if precedence[op] <= precedence[prev_op] do
        honor_precedence(op, [prev_op | output], rest, precedence)
      else
        {output, ops}
      end
    end

    def close(_token, _output, []), do: raise "unbalanced parens"
    def close(_token, output, ["(" | ops]), do: {output, ops}
    def close(token, output, [op | ops]) do
      close(token, [op | output], ops)
    end
  end

  defmodule Evaluator do
    @moduledoc """
    Evaluate a list of tokens (integers or operators) in RPN order
    """
    def evaluate(instructions) when is_list(instructions), do: evaluate(instructions, [])
    def evaluate([], [x]) when is_integer(x), do: x
    def evaluate(["+" | instructions], [x, y | acc]) when is_integer(x) and is_integer(y) do
      evaluate(instructions, [x + y | acc])
    end
    def evaluate(["*" | instructions], [x, y | acc]) when is_integer(x) and is_integer(y) do
      evaluate(instructions, [x * y | acc])
    end
    def evaluate([x | instructions], acc) when is_integer(x), do: evaluate(instructions, [x | acc])
  end

  def solution1(input) do
    input
    |> Enum.map(fn line ->
      line
      |> tokenize()
      |> Parser.parse(%{"+" => 0, "*" => 0})
      |> Evaluator.evaluate()
    end)
    |> Enum.sum()
  end

  @doc """
  --- Part Two ---
  You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they
  reach the next section: advanced math.

  Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar
  with. Instead, addition is evaluated before multiplication.

  For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

  1 + 2 * 3 + 4 * 5 + 6
    3   * 3 + 4 * 5 + 6
    3   *   7   * 5 + 6
    3   *   7   *  11
      21       *  11
          231

  Here are the other examples from above:

  1 + (2 * 3) + (4 * (5 + 6)) still becomes 51.
  2 * 3 + (4 * 5) becomes 46.
  5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
  5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
  ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.

  What do you get if you add up the results of evaluating the homework problems using these new rules?
  """

  def solution2(input) do
    input
    |> Enum.map(fn line ->
      line
      |> tokenize()
      |> Parser.parse(%{"+" => 1, "*" => 0})
      |> Evaluator.evaluate()
    end)
    |> Enum.sum()
  end

  def sample_input do
    ["1 + 2 * 3 + 4 * 5 + 6"]
  end

  def real_input do
    @real_input
  end
end
