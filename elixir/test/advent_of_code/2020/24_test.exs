defmodule AdventOfCode.Y2020.D24Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D24

  describe "solution1" do
    test "works for sample input" do
      assert D24.solution1(D24.sample_input) == 10
    end

    test "works for real input" do
      assert D24.solution1(D24.real_input) == 263
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D24.solution2(D24.sample_input) == 2208
    end

    test "works for real input" do
      assert D24.solution2(D24.real_input) == 3649
    end
  end
end
