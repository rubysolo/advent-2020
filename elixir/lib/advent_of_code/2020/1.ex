defmodule AdventOfCode.Y2020.D1 do
  alias AdventOfCode.Input
  @real_input Input.list_of_integers("2020/1.txt")

  @doc """
  Pairs solution optimizes by not testing flipped pairs (e.g. if we have tested {1, 2}, then we don't need to test
  {2, 1} as it will have the same sum and product)
  """
  def pairs([]), do: []

  def pairs([h | t]) do
    Enum.map(t, &{h, &1}) ++ pairs(t)
  end

  @spec solution1_pairs(list(integer())) :: integer()
  def solution1_pairs(input) do
    {x, y, _} =
      input
      |> pairs
      |> Enum.map(fn {x, y} -> {x, y, x + y} end)
      |> Enum.filter(fn {_, _, z} -> z == 2020 end)
      |> List.first()

    x * y
  end

  @doc """
  Generator solution is the most basic brute force solution
  """
  @spec solution1_generator(list(integer())) :: integer()
  def solution1_generator(input) do
    # find every pair
    [{i, j} | _] =
      for i <- input,
          j <- input,
          i != j,
          i + j == 2020,
          do: {i, j}

    i * j
  end

  @doc """
  Optimized solution splits input into 2 lists, based on whether the number is above or below the "middle" (2020 /
  2). "over" numbers are sorted in ascending order, "under" numbers are sorted in descending order. We test the
  pair formed by the heads of the over/under lists and if the sum is too small, we increase it by discarding the
  first (smallest) value in the "over" list and re-testing the heads, but if the sum is too big, we decrease it by
  discarding the first (largest) value in the "under" list and re-testing the heads.
  """
  def solution1_optimized(input) do
    middle = 2020 / 2

    {over, under} =
      input
      |> Enum.sort()
      |> Enum.split_with(&(&1 > middle))

    under = Enum.reverse(under)

    solution1_optimized(over, under)
  end

  def solution1_optimized([o | _], [u | _]) when o + u == 2020 do
    # found it!
    o * u
  end

  def solution1_optimized([o | _] = over, [u | under]) when o + u > 2020 do
    # too big, go to the next smaller number in the "under" list
    solution1_optimized(over, under)
  end

  def solution1_optimized([_ | over], [_ | _] = under) do
    # too small, go to the next larger number in the "over" list
    solution1_optimized(over, under)
  end

  def solution1_optimized(over, under) when length(over) == 0 or length(under) == 0 do
    # hopefully this never happens!
    raise "no solution"
  end

  @spec solution2(list(integer())) :: integer()
  def solution2(input) do
    # find every triple
    [{i, j, k} | _] =
      for i <- input,
          j <- input,
          k <- input,
          i != j,
          i != k,
          j != k,
          i + j + k == 2020,
          do: {i, j, k}

    i * j * k
  end

  @spec sample_input :: list(integer())
  def sample_input do
    [1721, 979, 366, 299, 675, 1456]
  end

  @spec real_input :: list(integer())
  def real_input do
    @real_input
  end
end
