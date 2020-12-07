defmodule AdventOfCode.Y2020.D7Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D7

  describe "solution1" do
    test "works for sample input" do
      assert D7.solution1(D7.sample_input) == 4
    end

    test "works for real input" do
      assert D7.solution1(D7.real_input) == 121
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D7.solution2(D7.sample_input) == 32
    end

    test "works for another sample input" do
      assert D7.solution2(D7.sample_input2) == 126
    end

    test "works for real input" do
      assert D7.solution2(D7.real_input) == 3805
    end
  end
end
