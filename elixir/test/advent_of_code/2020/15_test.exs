defmodule AdventOfCode.Y2020.D15Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D15

  describe "solution1" do
    test "works for sample input" do
      assert D15.solution1(D15.sample_input) == 436
      assert D15.solution1("1,3,2") == 1
      assert D15.solution1("2,1,3") == 10
      assert D15.solution1("1,2,3") == 27
      assert D15.solution1("2,3,1") == 78
      assert D15.solution1("3,2,1") == 438
      assert D15.solution1("3,1,2") == 1836
    end

    test "works for real input" do
      assert D15.solution1(D15.real_input) == 421
    end
  end

  describe "solution2" do
    @tag :skip
    test "works for sample input" do
      assert D15.solution2("0,3,6") == 175594
      # assert D15.solution2("1,3,2") == 2578
      # assert D15.solution2("2,1,3") == 3544142
      # assert D15.solution2("1,2,3") == 261214
      # assert D15.solution2("2,3,1") == 6895259
      # assert D15.solution2("3,2,1") == 18
      # assert D15.solution2("3,1,2") == 362
    end

    test "works for real input" do
      assert D15.solution2(D15.real_input) == 0
    end
  end
end
