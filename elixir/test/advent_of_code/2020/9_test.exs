defmodule AdventOfCode.Y2020.D9Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D9

  describe "solution1" do
    test "works for sample input" do
      assert D9.solution1(D9.sample_input, 5) == 127
    end

    @tag :skip
    test "works for real input" do
      assert D9.solution1(D9.real_input, 25) == 29221323
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D9.solution2(D9.sample_input, 127) == 62
    end

    @tag :skip
    test "works for real input" do
      assert D9.solution2(D9.real_input, 29221323) == 4389369
    end
  end
end
