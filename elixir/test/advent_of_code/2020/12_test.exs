defmodule AdventOfCode.Y2020.D12Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D12

  describe "solution1" do
    test "works for sample input" do
      assert D12.solution1(D12.sample_input) == 25
    end

    test "works for real input" do
      assert D12.solution1(D12.real_input) == 845
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D12.solution2(D12.sample_input) == 286
    end

    test "works for real input" do
      assert D12.solution2(D12.real_input) == 27016
    end
  end
end
