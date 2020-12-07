defmodule AdventOfCode.Y2020.D7 do
  @moduledoc """
  --- Day 7: Handy Haversacks ---
  You land at the regional airport in time for your next flight. In fact, it looks like you'll even have time to
  grab some food: all flights are currently delayed due to issues in luggage processing.

  Due to recent aviation regulations, many rules (your puzzle input) are being enforced about bags and their
  contents; bags must be color-coded and must contain specific quantities of other color-coded bags. Apparently,
  nobody responsible for these regulations considered how long they would take to enforce!

  For example, consider the following rules:

  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.

  These rules specify the required contents for 9 bag types. In this example, every faded blue bag is empty, every
  vibrant plum bag contains 11 bags (5 faded blue and 6 dotted black), and so on.

  You have a shiny gold bag. If you wanted to carry it in at least one other bag, how many different bag colors
  would be valid for the outermost bag? (In other words: how many colors can, eventually, contain at least one
  shiny gold bag?)

  In the above rules, the following options would be available to you:

  A bright white bag, which can hold your shiny gold bag directly.
  A muted yellow bag, which can hold your shiny gold bag directly, plus some other bags.
  A dark orange bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.
  A light red bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.

  So, in this example, the number of bag colors that can eventually contain at least one shiny gold bag is 4.

  How many bag colors can eventually contain at least one shiny gold bag? (The list of rules is quite long; make
  sure you get all of it.)
  """

  alias AdventOfCode.Input
  @real_input Input.raw("2020/7.txt")

  def solution1(input) do
    ruleset =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)
      |> Enum.reduce(%{}, &to_ruleset/2)

    all_containers_of(ruleset, "shiny gold")
    |> Enum.count()
  end

  def parse_rule(rule) do
    [container, contained] = String.split(rule, " contain ")
    container = String.replace(container, ~r/\s*bags?/, "")
    contained =
      String.split(contained, ", ")
      |> Enum.map(&String.replace(&1, ~r/\s*bags?\.?/, ""))
      |> Enum.map(&String.replace(&1, ~r/^\d*\s*/, ""))

    {container, contained}
  end

  def parse_rule_with_count(rule) do
    [container, contained] = String.split(rule, " contain ")

    container = String.replace(container, ~r/\s*bags?/, "")

    contained =
      String.split(contained, ", ")
      |> Enum.reject(fn c -> String.starts_with?(c, "no other") end)
      |> Enum.map(&String.replace(&1, ~r/\s*bags?\.?/, ""))
      |> Enum.map(fn c ->
        [count, color] = String.split(c, " ", parts: 2)
        {color, String.to_integer(count)}
      end)

    {container, contained}
  end

  def to_ruleset({container, contained}, acc) do
    contained
    |> Enum.reduce(acc, fn color, acc_ ->
      {_, updated} =
        Map.get_and_update(acc_, color, fn
          nil ->
            {nil, [container]}
          containers ->
            {containers, [container | containers]}
        end)

      updated
    end)
  end

  def all_containers_of(ruleset, color) do
    direct_containers =
      Map.get(ruleset, color, [])

    indirect_containers =
      direct_containers
      |> Enum.flat_map(&all_containers_of(ruleset, &1))

    Enum.uniq(direct_containers ++ indirect_containers)
  end

  @doc """
  It's getting pretty expensive to fly these days - not because of ticket prices, but because of the ridiculous
  number of bags you need to buy!

  Consider again your shiny gold bag and the rules from the above example:

  faded blue bags contain 0 other bags.
  dotted black bags contain 0 other bags.
  vibrant plum bags contain 11 other bags: 5 faded blue bags and 6 dotted black bags.
  dark olive bags contain 7 other bags: 3 faded blue bags and 4 dotted black bags.

  So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags within it) plus 2 vibrant plum bags
  (and the 11 bags within each of those): 1 + 1*7 + 2 + 2*11 = 32 bags!

  Of course, the actual rules have a small chance of going several levels deeper than this example; be sure to
  count all of the bags, even if the nesting becomes topologically impractical!

  Here's another example:

  shiny gold bags contain 2 dark red bags.
  dark red bags contain 2 dark orange bags.
  dark orange bags contain 2 dark yellow bags.
  dark yellow bags contain 2 dark green bags.
  dark green bags contain 2 dark blue bags.
  dark blue bags contain 2 dark violet bags.
  dark violet bags contain no other bags.

  In this example, a single shiny gold bag must contain 126 other bags.
  """

  def solution2(input) do
    ruleset =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule_with_count/1)
      |> Enum.into(%{})

    count_contained(ruleset, "shiny gold")
  end

  def count_contained(ruleset, color) do
    direct =
      ruleset
      |> Map.get(color, [])

    direct_count =
      direct
      |> Enum.map(&elem(&1, 1))
      |> Enum.sum

    indirect_count =
      direct
      |> Enum.map(fn {color, count} ->
        count_contained(ruleset, color) * count
      end)
      |> Enum.sum

    direct_count + indirect_count
  end

  def sample_input do
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """
  end

  def sample_input2 do
    """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """
  end

  def real_input do
    @real_input
  end
end
