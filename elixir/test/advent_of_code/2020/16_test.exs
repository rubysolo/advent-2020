defmodule AdventOfCode.Y2020.D16Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D16

  describe "solution1" do
    test "works for sample input" do
      assert D16.solution1(D16.sample_input) == 71
    end

    test "works for real input" do
      assert D16.solution1(D16.real_input) == 23925
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D16.solution2(D16.sample_input2) == %{
        "class" => 12, "row" => 11, "seat" => 13
      }
    end

    @tag :skip
    test "works for real input" do
      assert D16.solution2(D16.real_input) == 0
    end
  end
end
