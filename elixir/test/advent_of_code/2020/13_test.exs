defmodule AdventOfCode.Y2020.D13Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D13

  describe "solution1" do
    test "works for sample input" do
      assert D13.solution1(D13.sample_input) == 295
    end

    test "works for real input" do
      assert D13.solution1(D13.real_input) == 136
    end
  end

  describe "solution2" do
    test "works for simple input" do
      assert D13.solution2("x\n7,3,5") == 98
    end

    test "works for sample input" do
      assert D13.solution2(D13.sample_input) == 1068781
    end

    test "works for more sample inputs" do
      D13.other_samples()
      |> Enum.each(fn {k, v} ->
        assert D13.solution2("x\n#{k}") == v
      end)
    end

    test "works for real input" do
      assert D13.solution2(D13.real_input) == 305068317272992
    end
  end
end
