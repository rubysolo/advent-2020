defmodule AdventOfCode.Y2020.D9 do
  @moduledoc """
  --- Day 9: Encoding Error ---
  With your neighbor happily enjoying their video game, you turn your attention to an open data port on the little
  screen in the seat in front of you.

  Though the port is non-standard, you manage to connect it to your computer through the clever use of several
  paperclips. Upon connection, the port outputs a series of numbers (your puzzle input).

  The data appears to be encrypted with the eXchange-Masking Addition System (XMAS) which, conveniently for you,
  is an old cypher with an important weakness.

  XMAS starts by transmitting a preamble of 25 numbers. After that, each number you receive should be the sum of
  any two of the 25 immediately previous numbers. The two numbers will have different values, and there might be
  more than one such pair.

  For example, suppose your preamble consists of the numbers 1 through 25 in a random order. To be valid, the next
  number must be the sum of two of those numbers:

  26 would be a valid next number, as it could be 1 plus 25 (or many other pairs, like 2 and 24).
  49 would be a valid next number, as it is the sum of 24 and 25.
  100 would not be valid; no two of the previous 25 numbers sum to 100.
  50 would also not be valid; although 25 appears in the previous 25 numbers, the two numbers in the pair must be different.

  Suppose the 26th number is 45, and the first number (no longer an option, as it is more than 25 numbers ago) was
  20. Now, for the next number to be valid, there needs to be some pair of numbers among 1-19, 21-25, or 45 that
  add up to it:

  26 would still be a valid next number, as 1 and 25 are still within the previous 25 numbers.
  65 would not be valid, as no two of the available numbers sum to it.
  64 and 66 would both be valid, as they are the result of 19+45 and 21+45 respectively.
  Here is a larger example which only considers the previous 5 numbers (and has a preamble of length 5):

  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576

  In this example, after the 5-number preamble, almost every number is the sum of two of the previous 5 numbers;
  the only number that does not follow this rule is 127.

  The first step of attacking the weakness in the XMAS data is to find the first number in the list (after the
  preamble) which is not the sum of two of the 25 numbers before it. What is the first number that does not have
  this property?
  """
  alias AdventOfCode.Input
  @real_input Input.list_of_integers("2020/9.txt")

  defmodule FindSum do
    def find_sum(series, target) when is_list(series) do
      middle = div(target, 2)

      {over, under} =
        series
        |> Enum.sort()
        |> Enum.split_with(&(&1 > middle))

      under = Enum.reverse(under)

      find_sum(over, under, target)
    end

    def find_sum([o | _], [u | _], target) when o + u == target do
      # found it!
      o * u
    end

    def find_sum([o | _] = over, [u | under], target) when o + u > target do
      # too big, go to the next smaller number in the "under" list
      find_sum(over, under, target)
    end

    def find_sum([_ | over], [_ | _] = under, target) do
      # too small, go to the next larger number in the "over" list
      find_sum(over, under, target)
    end

    def find_sum(over, under, _target) when length(over) == 0 or length(under) == 0 do
      # hopefully this never happens!
      :no_solution
    end
  end

  def solution1(series, preamble_length) do
    preamble = Enum.take(series, preamble_length)
    remaining = Enum.drop(series, preamble_length)

    find_first_non_sum(preamble, remaining)
  end

  def find_first_non_sum(preamble, [h|rest]) do
    if FindSum.find_sum(preamble, h) == :no_solution do
      h
    else
      find_first_non_sum(Enum.drop(preamble, 1) ++ [h], rest)
    end
  end

  defmodule FindSequenceSum do
    def find_sequence_sum(series, target) do
      find_sequence_sum(series, target, 0)
    end

    def find_sequence_sum([_|_] = series, target, index) when index < length(series) do
      find_sequence_sum(series, target, index, index + 1) || find_sequence_sum(series, target, index + 1)
    end

    def find_sequence_sum([_|_] = series, target, lo, hi) do
      sub_sequence =
        series
        |> Enum.drop(lo)
        |> Enum.take(hi - lo)

      sum = Enum.sum(sub_sequence)

      cond do
        sum == target ->
          sub_sequence
        sum < target ->
          find_sequence_sum(series, target, lo, hi + 1)
        :otherwise ->
          nil
      end
    end
  end

  @doc """
  --- Part Two ---
  The final step in breaking the XMAS encryption relies on the invalid number you just found: you must find a
  contiguous set of at least two numbers in your list which sum to the invalid number from step 1.

  Again consider the above example:

  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576

  In this list, adding up all of the numbers from 15 through 40 produces the invalid number from step 1, 127. (Of
  course, the contiguous set of numbers in your actual list might be much longer.)

  To find the encryption weakness, add together the smallest and largest number in this contiguous range; in this
  example, these are 15 and 47, producing 62.

  What is the encryption weakness in your XMAS-encrypted list of numbers?
  """


  def solution2(input, target) do
    sub_sequence = FindSequenceSum.find_sequence_sum(input, target)
    Enum.min(sub_sequence) + Enum.max(sub_sequence)
  end

  def sample_input do
    [
      35,
      20,
      15,
      25,
      47,
      40,
      62,
      55,
      65,
      95,
      102,
      117,
      150,
      182,
      127,
      219,
      299,
      277,
      309,
      576
    ]
  end

  def real_input do
    @real_input
  end
end
