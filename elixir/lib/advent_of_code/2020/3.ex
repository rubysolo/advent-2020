defmodule AdventOfCode.Y2020.D3 do
  @moduledoc """
  """
  alias AdventOfCode.Input
  @real_input Input.lines("2020/3.txt")

  def solution1(input, slope \\ {3, 1})

  def solution1(input, {1, 2}) do
    [first_row, _next_row | rest] =
      input
      |> Enum.map(&String.graphemes/1)

    width = length(first_row)

    rest
    |> Enum.take_every(2)
    |> Enum.with_index(1)
    |> Enum.map(fn {row, index} ->
      col_index = rem(index, width)
      Enum.at(row, col_index)
    end)
    |> Enum.filter(&(&1 == "#"))
    |> length()
  end

  def solution1(input, {right, _down}) do
    [first_row | rest] =
      input
      |> Enum.map(&String.graphemes/1)

    width = length(first_row)

    rest
    |> Enum.with_index(1)
    |> Enum.map(fn {row, index} ->
      col_index = rem(index * right, width)
      Enum.at(row, col_index)
    end)
    |> Enum.filter(&(&1 == "#"))
    |> length()
  end

  def solution2(input) do
    slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]

    slopes
    |> Enum.map(&solution1(input, &1))
    |> Enum.reduce(fn a, prod -> a * prod end)
  end

  def sample_input do
    # copy/pasta here
    [
      "..##.......",
      "#...#...#..",
      ".#....#..#.",
      "..#.#...#.#",
      ".#...##..#.",
      "..#.##.....",
      ".#.#.#....#",
      ".#........#",
      "#.##...#...",
      "#...##....#",
      ".#..#...#.#"
    ]
  end

  def real_input do
    @real_input
  end
end
