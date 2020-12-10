defmodule AdventOfCode.Y2020.D10Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D10

  describe "solution1" do
    test "works for sample input" do
      assert D10.solution1(D10.sample_input) == 35
    end

    test "works for another sample input" do
      assert D10.solution1(D10.sample_input2) == 220
    end

    test "works for real input" do
      assert D10.solution1(D10.real_input) == 1885
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D10.solution2(D10.sample_input) == 8
    end

    test "works for another sample input" do
      assert D10.solution2(D10.sample_input2) == 19208
    end

    test "works for real input" do
      assert D10.solution2(D10.real_input) == 2024782584832
    end
  end
end
