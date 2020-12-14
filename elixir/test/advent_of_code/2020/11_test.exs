defmodule AdventOfCode.Y2020.D11Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D11

  # describe "finding neighbor coordinates" do
  #   test "corner case" do
  #     parsed  = D11.parse(["LL","LL"])
  #     assert D11.neighbors(parsed, {0, 0}) == [{0, 1}, {1, 0}, {1, 1}]
  #   end
  # end

  describe "solution1" do
    test "single iteration" do
      assert D11.empty()
             |> D11.parse()
             |> D11.Solution1.next()
             |> D11.render() == D11.full()
    end

    test "next iteration" do
      assert D11.full()
             |> D11.parse()
             |> D11.Solution1.next()
             |> D11.render() == D11.after_full()
    end

    test "works for sample input" do
      assert D11.solution1(D11.after_full) == 37
    end

    test "works for real input" do
      assert D11.solution1(D11.real_input) == 2334
    end
  end

  describe "solution2" do
    test "works for sample input" do
      assert D11.solution2(D11.full) == 26
    end

    test "works for real input" do
      assert D11.solution2(D11.real_input) == 2100
    end
  end
end
