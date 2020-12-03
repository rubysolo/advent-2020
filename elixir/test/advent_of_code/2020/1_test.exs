defmodule AdventOfCode.Y2020.D1Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D1

  test "it works" do
    assert D1.solution1_generator(D1.sample_input()) == 514_579
  end

  test "it works pairs" do
    assert D1.solution1_pairs(D1.sample_input()) == 514_579
  end

  test "it works optimized" do
    assert D1.solution1_optimized(D1.sample_input()) == 514_579
  end

  test "it works for real stuff" do
    assert D1.solution1_optimized(D1.real_input()) == 913_824
  end

  test "it works S2" do
    assert D1.solution2(D1.sample_input()) == 241_861_950
  end

  test "it works S2 for realz" do
    assert D1.solution2(D1.real_input()) == 240_889_536
  end
end
