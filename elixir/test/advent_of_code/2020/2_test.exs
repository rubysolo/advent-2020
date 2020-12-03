defmodule AdventOfCode.Y2020.D2Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D2

  describe "solution1" do
    test "works for sample input" do
      assert D2.solution1(D2.sample_input()) == 2
    end

    test "works for real input" do
      assert D2.solution1(D2.real_input()) == 564
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D2.solution2(D2.sample_input()) == 1
    end

    test "works for real input" do
      assert D2.solution2(D2.real_input()) == 325
    end
  end
end
