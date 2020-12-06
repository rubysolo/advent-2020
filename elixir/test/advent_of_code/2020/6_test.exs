defmodule AdventOfCode.Y2020.D6Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D6

  describe "solution1" do
    test "works for sample input" do
      assert D6.solution1(D6.sample_input) == 11
    end

    test "works for real input" do
      assert D6.solution1(D6.real_input) == 7110
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D6.solution2(D6.sample_input) == 6
    end

    test "works for real input" do
      assert D6.solution2(D6.real_input) == 3628
    end
  end
end
