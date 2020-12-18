defmodule AdventOfCode.Y2020.D18Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D18

  describe "solution1" do
    test "works for sample input" do
      assert D18.solution1(D18.sample_input) == 71
    end

    test "works with parens" do
      assert D18.solution1(["1 + (2 * 3) + (4 * (5 + 6))"]) == 51
      assert D18.solution1(["2 * 3 + (4 * 5)"]) == 26
      assert D18.solution1(["5 + (8 * 3 + 9 + 3 * 4 * 3)"]) == 437
      assert D18.solution1(["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"]) == 12240
      assert D18.solution1(["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"]) == 13632
    end

    test "works for real input" do
      assert D18.solution1(D18.real_input) == 31142189909908
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D18.solution2(D18.sample_input) == 231
    end

    test "works with parens" do
      assert D18.solution2(["1 + (2 * 3) + (4 * (5 + 6))"]) == 51
      assert D18.solution2(["2 * 3 + (4 * 5)"]) == 46
      assert D18.solution2(["5 + (8 * 3 + 9 + 3 * 4 * 3)"]) == 1445
      assert D18.solution2(["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"]) == 669060
      assert D18.solution2(["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"]) == 23340
    end

    test "works for real input" do
      assert D18.solution2(D18.real_input) == 323912478287549
    end
  end
end
