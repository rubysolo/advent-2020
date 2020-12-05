defmodule AdventOfCode.Y2020.D5Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D5

  describe "solution1" do
    test "works for sample input" do
      assert D5.solution1(D5.sample_input) == 357
    end

    test "works for real input" do
      assert D5.solution1(D5.real_input) == 878
    end
  end

  describe "solution2" do
    test "works for real input" do
      assert D5.solution2(D5.real_input) == 504
    end
  end
end
