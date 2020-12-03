defmodule AdventOfCode.Y2020.D3Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D3

  describe "solution1" do
    test "works for sample input" do
      assert D3.solution1(D3.sample_input()) == 7
    end

    test "works for real input" do
      assert D3.solution1(D3.real_input()) == 262
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D3.solution2(D3.sample_input()) == 336
    end

    test "works for real input" do
      assert D3.solution2(D3.real_input()) == 2698900776
    end
  end
end
