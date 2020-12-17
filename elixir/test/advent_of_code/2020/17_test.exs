defmodule AdventOfCode.Y2020.D17Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D17

  describe "solution1" do
    test "works for sample input" do
      assert D17.solution1(D17.sample_input) == 112
    end

    test "works for real input" do
      assert D17.solution1(D17.real_input) == 448
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D17.solution2(D17.sample_input) == 848
    end

    test "works for real input" do
      assert D17.solution2(D17.real_input) == 2400
    end
  end
end
