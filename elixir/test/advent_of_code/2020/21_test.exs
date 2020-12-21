defmodule AdventOfCode.Y2020.D21Test do
  use ExUnit.Case

  alias AdventOfCode.Y2020.D21

  describe "solution1" do
    test "works for sample input" do
      assert D21.solution1(D21.sample_input) == 5
    end

    test "works for real input" do
      assert D21.solution1(D21.real_input) == 2315
    end
  end

  describe "solution2" do
    @tag :skip
    test "works for sample input" do
      assert D21.solution2(D21.sample_input) == "mxmxvkd,sqjhc,fvjkl"
    end

    @tag :skip
    test "works for real input" do
      assert D21.solution2(D21.real_input) == "cfzdnz,htxsjf,ttbrlvd,bbbl,lmds,cbmjz,cmbcm,dvnbh"
    end
  end
end
