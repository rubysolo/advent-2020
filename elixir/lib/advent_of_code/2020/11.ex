defmodule AdventOfCode.Y2020.D11 do
  @moduledoc """
  --- Day 11: Seating System ---
  Your plane lands with plenty of time to spare. The final leg of your journey is a ferry that goes directly to
  the tropical island where you can finally start your vacation. As you reach the waiting area to board the ferry,
  you realize you're so early, nobody else has even arrived yet!

  By modeling the process people use to choose (or abandon) their seat in the waiting area, you're pretty sure you
  can predict the best place to sit. You make a quick map of the seat layout (your puzzle input).

  The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat
  (#). For example, the initial seat layout might look like this:

  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL

  Now, you just need to model the people who will be arriving shortly. Fortunately, people are entirely
  predictable and always follow a simple set of rules. All decisions are based on the number of occupied seats
  adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the
  seat). The following rules are applied to every seat simultaneously:

  If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  Otherwise, the seat's state does not change.
  Floor (.) never changes; seats don't move, and nobody sits on the floor.

  After one round of these rules, every seat in the example layout becomes occupied:

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  After a second round, the seats with four or more occupied adjacent seats become empty again:

  #.LL.L#.##
  #LLLLLL.L#
  L.L.L..L..
  #LLL.LL.L#
  #.LL.LL.LL
  #.LLLL#.##
  ..L.L.....
  #LLLLLLLL#
  #.LLLLLL.L
  #.#LLLL.##

  This process continues for three more rounds:

  #.##.L#.##
  #L###LL.L#
  L.#.#..#..
  #L##.##.L#
  #.##.LL.LL
  #.###L#.##
  ..#.#.....
  #L######L#
  #.LL###L.L
  #.#L###.##

  #.#L.L#.##
  #LLL#LL.L#
  L.L.L..#..
  #LLL.##.L#
  #.LL.LL.LL
  #.LL#L#.##
  ..L.L.....
  #L#LLLL#L#
  #.LLLLLL.L
  #.#L#L#.##

  #.#L.L#.##
  #LLL#LL.L#
  L.#.L..#..
  #L##.##.L#
  #.#L.LL.LL
  #.#L#L#.##
  ..L.L.....
  #L#L##L#L#
  #.LLLLLL.L
  #.#L#L#.##

  At this point, something interesting happens: the chaos stabilizes and further applications of these rules cause
  no seats to change state! Once people stop moving around, you count 37 occupied seats.

  Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats
  end up occupied?
  """
  alias AdventOfCode.Input
  @real_input Input.lines("2020/11.txt")

  # def neighbors(%{grid: grid}, coord) when is_atom(grid) do
  #   grid.neighbors(coord)
  # end

  # def neighbors(%{} = state, coord) do
  #   neighbors(%{ state | grid: compile(state) }, coord)
  # end

  defmodule Solution1 do
    def solve(%{} = state) do
      n = next(state)
      if n == state do
        freqs =
          n
          |> Map.values()
          |> Enum.frequencies()

        Map.get(freqs, "#", 0)
      else
        solve(n)
      end
    end

    def next(%{} = state) do
      state
      |> Map.keys
      |> Enum.reduce(%{}, fn coord, acc ->
        Map.put(acc, coord, next(coord, state))
      end)
    end

    def next({_, _} = coord, %{} = state) do
      state
      |> Map.get(coord, ".")
      |> next(coord, state)
    end

    def next(".", _coord, _) do
      "."
    end

    def next("L", coord, %{} = state) do
      freqs =
        neighbors(coord, state)
        |> Enum.frequencies()

      if Map.get(freqs, "#", 0) == 0, do: "#", else: "L"
    end

    def next("#", coord, %{} = state) do
      freqs =
        neighbors(coord, state)
        |> Enum.frequencies()

      if Map.get(freqs, "#", 0) >= 4, do: "L", else: "#"
    end

    def neighbors({col, row}, %{} = state) do
      coordinates =
        for r <- (row - 1)..(row + 1),
            c <- (col - 1)..(col + 1),
            {c, r} != {col, row},
            do: {c, r}

      Enum.map(coordinates, & Map.get(state, &1, "."))
    end
  end

  def parse([_|_] = rows) do
    rows
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, row_index}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col_index}, acc_ ->
        Map.put(acc_, {col_index, row_index}, char)
      end)
    end)
  end

  def render(%{} = state) do
    keys = Map.keys(state)
    cols = Enum.map(keys, &elem(&1, 0)) |> Enum.max
    rows = Enum.map(keys, &elem(&1, 1)) |> Enum.max

    0..rows
    |> Enum.map(fn row_index ->
      0..cols
      |> Enum.map(fn col_index ->
        Map.get(state, {col_index, row_index})
      end)
      |> Enum.join()
    end)
  end

  def solution1(input) when is_list(input) do
    input
    |> parse()
    |> Solution1.solve
  end

  @doc """
  --- Part Two ---
  As soon as people start to arrive, you realize your mistake. People don't just care about adjacent seats - they
  care about the first seat they can see in each of those eight directions!

  Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those
  eight directions. For example, the empty seat below would see eight occupied seats:

  .......#.
  ...#.....
  .#.......
  .........
  ..#L....#
  ....#....
  .........
  #........
  ...#.....

  The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:

  .............
  .L.L.#.#.#.#.
  .............

  The empty seat below would see no occupied seats:

  .##.##.
  #.#.#.#
  ##...##
  ...L...
  ##...##
  #.#.#.#
  .##.##.

  Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats for an
  occupied seat to become empty (rather than four or more from the previous rules). The other rules still apply:
  empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never
  changes.

  Given the same starting layout as above, these new rules cause the seating area to shift around as follows:

  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  #.LL.LL.L#
  #LLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLL#
  #.LLLLLL.L
  #.LLLLL.L#

  #.L#.##.L#
  #L#####.LL
  L.#.#..#..
  ##L#.##.##
  #.##.#L.##
  #.#####.#L
  ..#.#.....
  LLL####LL#
  #.L#####.L
  #.L####.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##LL.LL.L#
  L.LL.LL.L#
  #.LLLLL.LL
  ..L.L.....
  LLLLLLLLL#
  #.LLLLL#.L
  #.L#LL#.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##L#.#L.L#
  L.L#.#L.L#
  #.L####.LL
  ..#.#.....
  LLL###LLL#
  #.LLLLL#.L
  #.L#LL#.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##L#.#L.L#
  L.L#.LL.L#
  #.LLLL#.LL
  ..#.L.....
  LLL###LLL#
  #.LLLLL#.L
  #.L#LL#.L#

  Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs,
  you count 26 occupied seats.

  Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is
  reached, how many seats end up occupied?
  """
  defmodule Solution2 do
    def solve(%{} = state) do
      n = next(state, size(state))
      if n == state do
        freqs =
          n
          |> Map.values()
          |> Enum.frequencies()

        Map.get(freqs, "#", 0)
      else
        solve(n)
      end
    end

    def next(%{} = state, dims) do
      state
      |> Map.keys
      |> Enum.reduce(%{}, fn coord, acc ->
        Map.put(acc, coord, next(coord, state, dims))
      end)
    end

    def next({_, _} = coord, %{} = state, {_, _} = dims) do
      state
      |> Map.get(coord, ".")
      |> next(coord, state, dims)
    end

    def next(".", _coord, _, _) do
      "."
    end

    def next("L", coord, %{} = state, dims) do
      freqs =
        visible(coord, state, dims)
        |> Enum.frequencies()

      if Map.get(freqs, "#", 0) == 0, do: "#", else: "L"
    end

    def next("#", coord, %{} = state, dims) do
      freqs =
        visible(coord, state, dims)
        |> Enum.frequencies()

      if Map.get(freqs, "#", 0) >= 5, do: "L", else: "#"
    end

    def size(%{} = state) do
      keys = Map.keys(state)
      cols = Enum.map(keys, &elem(&1, 0)) |> Enum.max
      rows = Enum.map(keys, &elem(&1, 1)) |> Enum.max
      {cols, rows}
    end

    def visible({col, row}, %{} = state, {w, h}) do
      # N
      n_cols = 0..(col-1) |> Enum.reverse
      n = Enum.map(n_cols, &{&1, row}) |> first_visible(state)

      # E
      e_rows = row+1..h
      e = Enum.map(e_rows, &{col, &1}) |> first_visible(state)

      # S
      s_cols = col+1..w
      s = Enum.map(s_cols, &{&1, row}) |> first_visible(state)

      # W
      w_rows = 0..row-1 |> Enum.reverse
      w = Enum.map(w_rows, &{col, &1}) |> first_visible(state)

      # NE
      ne = Enum.zip(n_cols, e_rows) |> first_visible(state)

      # SE
      se = Enum.zip(s_cols, e_rows) |> first_visible(state)

      # SW
      sw = Enum.zip(s_cols, w_rows) |> first_visible(state)

      # NW
      nw = Enum.zip(n_cols, w_rows) |> first_visible(state)

      [n, e, s, w, ne, se, sw, nw]
    end

    def first_visible(coords, state) do
      coords
      |> Stream.map(fn c -> Map.get(state, c) end)
      |> Stream.drop_while(& &1 == ".")
      |> Enum.take(1)
      |> List.first() || "."
    end
  end


  def solution2(input) do
    input
    |> parse()
    |> Solution2.solve
  end

  def empty do
    [
      "L.LL.LL.LL",
      "LLLLLLL.LL",
      "L.L.L..L..",
      "LLLL.LL.LL",
      "L.LL.LL.LL",
      "L.LLLLL.LL",
      "..L.L.....",
      "LLLLLLLLLL",
      "L.LLLLLL.L",
      "L.LLLLL.LL",
    ]
  end

  def full do
    [
      "#.##.##.##",
      "#######.##",
      "#.#.#..#..",
      "####.##.##",
      "#.##.##.##",
      "#.#####.##",
      "..#.#.....",
      "##########",
      "#.######.#",
      "#.#####.##",
    ]
  end

  def after_full do
    [
      "#.LL.L#.##",
      "#LLLLLL.L#",
      "L.L.L..L..",
      "#LLL.LL.L#",
      "#.LL.LL.LL",
      "#.LLLL#.##",
      "..L.L.....",
      "#LLLLLLLL#",
      "#.LLLLLL.L",
      "#.#LLLL.##",
    ]
  end

  def real_input do
    @real_input
  end
end
