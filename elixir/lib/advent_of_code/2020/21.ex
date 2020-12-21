defmodule AdventOfCode.Y2020.D21 do
  @moduledoc """
  --- Day 21: Allergen Assessment ---
  You reach the train's last stop and the closest you can get to your vacation island without getting wet. There
  aren't even any boats here, but nothing can stop you now: you build a raft. You just need a few days' worth of
  food for your journey.

  You don't speak the local language, so you can't read any ingredients lists. However, sometimes, allergens are
  listed in a language you do understand. You should be able to use this information to determine which ingredient
  contains which allergen and work out which foods are safe to take with you on your trip.

  You start by compiling a list of foods (your puzzle input), one food per line. Each line includes that food's
  ingredients list followed by some or all of the allergens the food contains.

  Each allergen is found in exactly one ingredient. Each ingredient contains zero or one allergen. Allergens
  aren't always marked; when they're listed (as in (contains nuts, shellfish) after an ingredients list), the
  ingredient that contains each listed allergen will be somewhere in the corresponding ingredients list. However,
  even if an allergen isn't listed, the ingredient that contains that allergen could still be present: maybe they
  forgot to label it, or maybe it was labeled in a language you don't know.

  For example, consider the following list of foods:

  mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
  trh fvjkl sbzzf mxmxvkd (contains dairy)
  sqjhc fvjkl (contains soy)
  sqjhc mxmxvkd sbzzf (contains fish)

  The first food in the list has four ingredients (written in a language you don't understand): mxmxvkd, kfcds,
  sqjhc, and nhms. While the food might contain other allergens, a few allergens the food definitely contains are
  listed afterward: dairy and fish.

  The first step is to determine which ingredients can't possibly contain any of the allergens in any food in your
  list. In the above example, none of the ingredients kfcds, nhms, sbzzf, or trh can contain an allergen. Counting
  the number of times any of these ingredients appear in any ingredients list produces 5: they all appear once
  each except sbzzf, which appears twice.

  Determine which ingredients cannot possibly contain any of the allergens in your list. How many times do any of
  those ingredients appear?
  """
  alias AdventOfCode.Input
  @real_input Input.lines("2020/21.txt")

  def parse_food_list(lines) do
    lines
    |> Enum.with_index()
    |> Enum.map(fn {line, index} ->
      [ingredients, allergens] =
        line
        |> String.replace(")", "")
        |> String.split(" (contains ")

      raw_ingredients = String.split(ingredients, " ")

      %{
        allergens:       String.split(allergens, ", ") |> MapSet.new(),
        index:           index,
        ingredients:     raw_ingredients |> MapSet.new(),
        raw_ingredients: raw_ingredients,
      }
    end)
  end

  # def eliminate_matches(food_list) do
  #   all_pairs = for food1 <- food_list,
  #                   food2 <- food_list,
  #                   food1 != food2, do: {food1, food2}

  #   case find_match(all_pairs) do
  #     {f1, f2} ->
  #       IO.puts("found match, eliminating...")
  #       ingredient_match = MapSet.intersection(f1.ingredients, f2.ingredients) |> MapSet.to_list() |> List.first()
  #       allergen_match = MapSet.intersection(f1.allergens, f2.allergens) |> MapSet.to_list() |> List.first()

  #       {ingredient_match, allergen_match}

  #       food_list
  #       |> Enum.map(fn food ->
  #         %{ food |
  #           ingredients: food.ingredients |> MapSet.delete(ingredient_match),
  #           allergens:   food.allergens |> MapSet.delete(allergen_match),
  #         }
  #       end)
  #       |> eliminate_matches()
  #     nil ->
  #       IO.puts("no matches to be found.")
  #       # must be done
  #       food_list
  #   end
  # end

  # def find_match(pairs) do
  #   Enum.find(pairs, fn {f1, f2} ->
  #     ingredient_match_count =
  #       MapSet.intersection(f1.ingredients, f2.ingredients)
  #       |> IO.inspect(label: "ingredient intersection between (#{f1.index} & #{f2.index})")
  #       |> MapSet.size()

  #     allergen_match_count =
  #       MapSet.intersection(f1.allergens, f2.allergens)
  #       |> IO.inspect(label: "allergen intersection between (#{f1.index} & #{f2.index})")
  #       |> MapSet.size()

  #     ingredient_match_count == allergen_match_count && ingredient_match_count > 0
  #   end)
  # end

  def common_ingredients(food_list, allergen) do
    food_list
    |> Enum.filter(&MapSet.member?(&1.allergens, allergen))
    |> Enum.map(& &1.ingredients)
    |> Enum.reduce(&MapSet.intersection/2)
  end

  def eliminate_allergen(food_list, {allergen, ingredient}) do
    food_list
    |> Enum.map(fn food ->
      %{ food |
        ingredients: food.ingredients |> MapSet.delete(ingredient),
        allergens:   food.allergens   |> MapSet.delete(allergen),
      }
    end)
  end

  def eliminate_allergens(food_list, allergens) do
    case find_match(food_list, allergens) do
      {allergen, ingredient} ->
        IO.puts("#{allergen} = #{ingredient}")
        food_list
        |> eliminate_allergen({allergen, ingredient})
        |> eliminate_allergens(MapSet.delete(allergens, allergen))
      _ ->
        food_list
    end
  end

  def find_match(food_list, allergens) do
    allergens
    |> Enum.find_value(fn allergen ->
      ingredients = common_ingredients(food_list, allergen)
      if MapSet.size(ingredients) == 1 do
        {allergen, ingredients |> MapSet.to_list |> List.first}
      else
        false
      end
    end)
  end

  def solution1(lines) do
    food_list =
      lines
      |> parse_food_list()

    food_list
    |> Enum.map(& &1.ingredients)
    |> Enum.reduce(&MapSet.union/2)
    |> MapSet.size()
    |> IO.inspect(label: "starting ingredient count:")

    allergens =
      food_list
      |> Enum.map(& &1.allergens)
      |> Enum.reduce(&MapSet.union/2)

    non_allergens =
      food_list
      |> eliminate_allergens(allergens)
      |> Enum.map(& &1.ingredients)
      |> Enum.reduce(&MapSet.union/2)

    food_list
    |> Enum.flat_map(& &1.raw_ingredients)
    |> Enum.filter(& MapSet.member?(non_allergens, &1))
    |> Enum.count()
  end

  @doc """
  --- Part Two ---
  Now that you've isolated the inert ingredients, you should have enough information to figure out which
  ingredient contains which allergen.

  In the above example:

  mxmxvkd contains dairy.
  sqjhc contains fish.
  fvjkl contains soy.

  Arrange the ingredients alphabetically by their allergen and separate them by commas to produce your canonical
  dangerous ingredient list. (There should not be any spaces in your canonical dangerous ingredient list.) In the
  above example, this would be mxmxvkd,sqjhc,fvjkl.

  Time to stock your raft with supplies. What is your canonical dangerous ingredient list?
  """


  def solution2(input) do
  end

  def sample_input do
    [
      "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)",
      "trh fvjkl sbzzf mxmxvkd (contains dairy)",
      "sqjhc fvjkl (contains soy)",
      "sqjhc mxmxvkd sbzzf (contains fish)",
    ]
  end

  def real_input do
    @real_input
  end
end
