defmodule AdventOfCode.Y2020.D8Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D8

  describe "solution1" do
    test "works for sample input" do
      state = D8.solution1(D8.sample_input)
      assert state.acc == 5
    end

    test "works for real input" do
      state = D8.solution1(D8.real_input)
      assert state.acc == 1797
    end
  end

  describe "solution2" do
    test "works for sample input" do
      state = D8.solution2(D8.sample_input)
      assert state.acc == 8
    end

    test "works for real input" do
      state = D8.solution2(D8.real_input)
      assert state.acc == 1036
    end
  end
end
