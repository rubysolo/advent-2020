defmodule AdventOfCode.Y2020.D14Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D14

  describe "solution1" do
    test "works for sample input" do
      assert D14.solution1(D14.sample_input) == 165
    end

    test "works for real input" do
      assert D14.solution1(D14.real_input) == 15172047086292
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D14.solution2(D14.sample_input2) == 208
    end

    test "works for real input" do
      assert D14.solution2(D14.real_input) == 4197941339968
    end
  end
end
