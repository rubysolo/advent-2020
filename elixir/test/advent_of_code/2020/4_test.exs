defmodule AdventOfCode.Y2020.D4Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D4

  describe "solution1" do
    test "works for sample input" do
      assert D4.solution1(D4.sample_input) == 2
    end

    test "works for real input" do
      assert D4.solution1(D4.real_input) == 196
    end
  end

  describe "solution2" do
    test "valid passports are valid" do
      D4.valid_passport_input()
      |> String.split("\n\n", trim: true)
      |> Enum.map(&D4.parse_passport/1)
      |> Enum.each(fn p -> assert D4.valid?(p) end)
    end

    test "invalid passports are invalid" do
      D4.invalid_passport_input()
      |> String.split("\n\n", trim: true)
      |> Enum.map(&D4.parse_passport/1)
      |> Enum.each(fn p -> refute D4.valid?(p) end)
    end

    test "works for real input" do
      assert D4.solution2(D4.real_input) == 114
    end
  end
end
