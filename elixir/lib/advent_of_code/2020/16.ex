defmodule AdventOfCode.Y2020.D16 do
  @moduledoc """
  --- Day 16: Ticket Translation ---
  As you're walking to yet another connecting flight, you realize that one of the legs of your re-routed trip
  coming up is on a high-speed train. However, the train ticket you were given is in a language you don't
  understand. You should probably figure out what it says before you get to the train station after the next
  flight.

  Unfortunately, you can't actually read the words on the ticket. You can, however, read the numbers, and so you
  figure out the fields these tickets must have and the valid ranges for values in those fields.

  You collect the rules for ticket fields, the numbers on your ticket, and the numbers on other nearby tickets for
  the same train service (via the airport security cameras) together into a single document you can reference
  (your puzzle input).

  The rules for ticket fields specify a list of fields that exist somewhere on the ticket and the valid ranges of
  values for each field. For example, a rule like class: 1-3 or 5-7 means that one of the fields in every ticket
  is named class and can be any value in the ranges 1-3 or 5-7 (inclusive, such that 3 and 5 are both valid in
  this field, but 4 is not).

  Each ticket is represented by a single line of comma-separated values. The values are the numbers on the ticket
  in the order they appear; every ticket has the same format. For example, consider this ticket:

  .--------------------------------------------------------.
  | ????: 101    ?????: 102   ??????????: 103     ???: 104 |
  |                                                        |
  | ??: 301  ??: 302             ???????: 303      ??????? |
  | ??: 401  ??: 402           ???? ????: 403    ????????? |
  '--------------------------------------------------------'

  Here, ? represents text in a language you don't understand. This ticket might be represented as
  101,102,103,104,301,302,303,401,402,403; of course, the actual train tickets you're looking at are much more
  complicated. In any case, you've extracted just the numbers in such a way that the first number is always the
  same specific field, the second number is always a different specific field, and so on - you just don't know
  what each position actually means!

  Start by determining which tickets are completely invalid; these are tickets that contain values which aren't
  valid for any field. Ignore your ticket for now.

  For example, suppose you have the following notes:

  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12

  It doesn't matter which position corresponds to which field; you can identify invalid nearby tickets by
  considering only whether tickets contain values that are not valid for any field. In this example, the values on
  the first nearby ticket are all valid for at least one field. This is not true of the other three nearby
  tickets: the values 4, 55, and 12 are are not valid for any field. Adding together all of the invalid values
  produces your ticket scanning error rate: 4 + 55 + 12 = 71.

  Consider the validity of the nearby tickets you scanned. What is your ticket scanning error rate?
  """
  alias AdventOfCode.Input
  @real_input Input.raw("2020/16.txt")

  def sections(raw) do
    raw
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.trim/1)
  end

  def lines(section) do
    section
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
  end

  def notes(raw_notes) do
    raw_notes
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [label, ranges] ->
      ranges =
        ranges
        |> String.split(" or ")
        |> Enum.map(fn s -> String.split(s, "-") |> Enum.map(&String.to_integer/1) end)
      {label, ranges}
    end)
    |> Enum.into(%{})
  end

  def ticket(raw_ticket) do
    raw_ticket
    |> List.last()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def invalid_values(tickets, valid_ranges) do
    tickets
    |> Enum.flat_map(&ticket_invalid_values(&1, valid_ranges))
  end

  def ticket_invalid_values(ticket, valid_ranges) do
    ticket
    |> Enum.filter(fn x ->
      ! Enum.any?(valid_ranges, fn r ->
        Enum.member?(r, x)
      end)
    end)
  end

  def solution1(input) do
    [raw_notes, _ticket, nearby] =
      input
      |> sections()
      |> Enum.map(&lines/1)

    notes = notes(raw_notes)
    valid_ranges =
      notes
      |> Map.values()
      |> Enum.reduce([], & &1 ++ &2)
      |> Enum.map(fn [lo, hi] -> Range.new(lo, hi) end)

    nearby = Enum.drop(nearby, 1) |> Enum.map(fn s -> String.split(s, ",") |> Enum.map(&String.to_integer/1) end)

    invalid_values(nearby, valid_ranges) |> Enum.sum()
  end

  @doc """
  --- Part Two ---
  Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the
  remaining valid tickets to determine which field is which.

  Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is
  consistent between all tickets: if seat is the third field, it is the third field on every ticket, including
  your ticket.

  For example, suppose you have the following notes:

  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9

  Based on the nearby tickets in the above example, the first position must be row, the second position must be
  class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and
  seat is 13.

  Once you work out which field is which, look for the six fields on your ticket that start with the word
  departure. What do you get if you multiply those six values together?
  """

  # def discard_invalid_tickets(tickets, valid_ranges) do
  #   tickets
  #   |> Enum.filter(fn t ->
  #     all_fields_valid(t, valid_ranges)
  #   end)
  # end

  # def all_fields_valid(ticket, valid_ranges) do
  #   ticket
  #   |> Enum.all?(fn field ->
  #     Enum.any?(valid_ranges, & Enum.member?(&1, field))
  #   end)
  # end

  def map_fields(ticket, valid_ranges) do
    ticket
    |> Enum.map(fn field ->
      map_field(field, valid_ranges)
    end)
  end

  def map_field(field, valid_ranges) do
    valid_ranges
    |> Enum.map(fn {label, ranges} ->
      possible =
        ranges
        |> Enum.any?( &Enum.member?(&1, field) )
      { label, possible }
    end)
    |> Enum.into(%{})
  end

  def solution2(input) do
    [raw_notes, ticket, nearby] =
      input
      |> sections()
      |> Enum.map(&lines/1)

    notes = notes(raw_notes)
    valid_ranges =
      notes
      |> Enum.map(fn {k, v} ->
        {k, v |> Enum.map(fn [lo, hi] -> Range.new(lo, hi) end)}
      end)
      |> Enum.into(%{})

    nearby =
      nearby
      |> Enum.drop(1)
      |> Enum.map(fn s ->
        String.split(s, ",")
        |> Enum.map(&String.to_integer/1)
      end)

    mapped =
      nearby
      |> Enum.reduce(%{}, fn ticket, acc ->
        fields = map_fields(ticket, valid_ranges)

        if fields |> Enum.map(&Map.values/1) |> Enum.any?(fn possibilities -> ! Enum.any?(possibilities, & &1) end) do
          acc
        else
          fields
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {possibilities, index}, acc_ ->
            Map.get_and_update(acc_, index, fn
              nil -> {nil, possibilities}
              existing -> {existing, false_wins_merge(existing, possibilities)}
            end)
            |> elem(1)
          end)
        end
      end)

    mapping = eliminate(mapped)

    ticket
    |> List.last()
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.map(fn {value, index} ->
      {Map.get(mapping, index), String.to_integer(value)}
    end)
    |> Enum.into(%{})
  end

  @doc """
  %{"arrival location" => 101,
  "arrival platform" => 139,
   "arrival station" => 107,
   "arrival track" => 97,
   "class" => 109,

   "departure date" => 137,
   "departure location" => 103,
   "departure platform" => 157,
   "departure station" => 73,
   "departure time" => 67,
   "departure track" => 89,

   "duration" => 191,
   "price" => 59,
   "route" => 179,
   "row" => 79,
   "seat" => 181,
   "train" => 53,
   "type" => 61,
   "wagon" => 113
   "zone" => 71}
  """

  def false_wins_merge(map1, map2) do
    keys = (Map.keys(map1) ++ Map.keys(map2)) |> Enum.uniq()

    keys
    |> Enum.reduce(%{}, fn key, acc ->
      Map.put(acc, key, Map.get(map1, key) && Map.get(map2, key))
    end)
  end

  def eliminate(column_possibilities) do
    values = Map.values(column_possibilities)
    if Enum.any?(values, &match?(%{}, &1)) do
      one_step =
        column_possibilities
        |> Enum.map(fn
          {k, %{} = v} ->
            field_possibilities = Enum.filter(v, fn {_field, possible} -> possible end) |> Enum.map(&elem(&1, 0))
            if Enum.count(field_possibilities) == 1 do
              {k, List.first(field_possibilities)}
            else
              {k, v}
            end

          {k, v} -> {k, v}
        end)

      determined =
        one_step
        |> Enum.filter(fn {_, v} -> ! match?(%{}, v) end)
        |> Enum.map(&elem(&1, 1))

      one_step
      |> Enum.map(fn
        {k, %{} = v} ->

          {k, v |> Enum.map(fn {field, possible} ->
            {field, !Enum.member?(determined, field) && possible}
          end) |> Enum.into(%{})}

        {k, v} -> {k, v}
      end)
      |> Enum.into(%{})
      |> eliminate()

    else
      column_possibilities
    end
  end

  def sample_input do
    """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """
  end

  def sample_input2 do
    """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    """
  end

  def real_input do
    @real_input
  end
end
