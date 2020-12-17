defmodule AdventOfCode.Y2020.D17 do
  @moduledoc """
  --- Day 17: Conway Cubes ---
  As your flight slowly drifts through the sky, the Elves at the Mythical Information Bureau at the North Pole
  contact you. They'd like some help debugging a malfunctioning experimental energy source aboard one of their
  super-secret imaging satellites.

  The experimental energy source is based on cutting-edge technology: a set of Conway Cubes contained in a pocket
  dimension! When you hear it's having problems, you can't help but agree to take a look.

  The pocket dimension contains an infinite 3-dimensional grid. At every integer 3-dimensional coordinate (x,y,z),
  there exists a single cube which is either active or inactive.

  In the initial state of the pocket dimension, almost all cubes start inactive. The only exception to this is a
  small flat region of cubes (your puzzle input); the cubes in this region start in the specified active (#) or
  inactive (.) state.

  The energy source then proceeds to boot up by executing six cycles.

  Each cube only ever considers its neighbors: any of the 26 other cubes where any of their coordinates differ by
  at most 1. For example, given the cube at x=1,y=2,z=3, its neighbors include the cube at x=2,y=2,z=2, the cube
  at x=0,y=2,z=3, and so on.

  During a cycle, all cubes simultaneously change their state according to the following rules:

  If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the
  cube becomes inactive. If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active.
  Otherwise, the cube remains inactive. The engineers responsible for this experimental energy source would like
  you to simulate the pocket dimension and determine what the configuration of cubes should be at the end of the
  six-cycle boot process.

  For example, consider the following initial state:

  .#.
  ..#
  ###

  Even though the pocket dimension is 3-dimensional, this initial state represents a small 2-dimensional slice of
  it. (In particular, this initial state defines a 3x3x1 region of the 3-dimensional space.)

  Simulating a few cycles from this initial state produces the following configurations, where the result of each
  cycle is shown layer-by-layer at each given z coordinate:

  Before any cycles:

  z=0
  .#.
  ..#
  ###


  After 1 cycle:

  z=-1
  #..
  ..#
  .#.

  z=0
  #.#
  .##
  .#.

  z=1
  #..
  ..#
  .#.


  After 2 cycles:

  z=-2
  .....
  .....
  ..#..
  .....
  .....

  z=-1
  ..#..
  .#..#
  ....#
  .#...
  .....

  z=0
  ##...
  ##...
  #....
  ....#
  .###.

  z=1
  ..#..
  .#..#
  ....#
  .#...
  .....

  z=2
  .....
  .....
  ..#..
  .....
  .....


  After 3 cycles:

  z=-2
  .......
  .......
  ..##...
  ..###..
  .......
  .......
  .......

  z=-1
  ..#....
  ...#...
  #......
  .....##
  .#...#.
  ..#.#..
  ...#...

  z=0
  ...#...
  .......
  #......
  .......
  .....##
  .##.#..
  ...#...

  z=1
  ..#....
  ...#...
  #......
  .....##
  .#...#.
  ..#.#..
  ...#...

  z=2
  .......
  .......
  ..##...
  ..###..
  .......
  .......
  .......

  After the full six-cycle boot process completes, 112 cubes are left in the active state.

  Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state
  after the sixth cycle?
  """

  alias AdventOfCode.Input
  @real_input Input.raw("2020/17.txt")

  defmodule Cube do
    # x, y, z are integers
    defstruct [:x, :y, :z]
  end

  defmodule HyperCube do
    # x, y, z, w are integers
    defstruct [:x, :y, :z, :w]
  end

  defmodule Bounds do
    # x, y, z are ranges
    defstruct [:x, :y, :z]
  end

  defmodule HyperBounds do
    # x, y, z are ranges
    defstruct [:x, :y, :z, :w]
  end

  def initialize(input, dims \\ 3) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, acc_ ->
        cube = case dims do
          3 -> %Cube{x: x, y: y, z: 0}
          4 -> %HyperCube{x: x, y: y, z: 0, w: 0}
        end
        Map.put(acc_, cube, cell == "#")
      end)
    end)
  end

  def step(state, _dims, 0), do: Map.values(state) |> Enum.filter(& &1) |> length()
  def step(state, dims, n) do
    state
    |> next_state(dims)
    |> step(dims, n - 1)
  end

  def next_state(%{} = state, dims) do
    coords =
      state
      |> find_bounds(dims)
      |> grid_search()

    coords
    |> Enum.reduce(%{}, fn cube, acc ->
      live_neighbor_count =
        cube
        |> neighbors()
        |> Enum.map(& Map.get(state, &1, false))
        |> Enum.filter(& &1)
        |> Enum.count()

      cube_state = Map.get(state, cube, false)
      next_cube_state = next_state(cube_state, live_neighbor_count)

      if next_cube_state do
        Map.put(acc, cube, true)
      else
        acc
      end
    end)
  end

  def next_state(true, live_neighbor_count) do
    live_neighbor_count == 2 || live_neighbor_count == 3
  end

  def next_state(false, live_neighbor_count) do
    live_neighbor_count == 3
  end

  def grid_search(%Bounds{x: x, y: y, z: z}) do
    for cx <- x,
        cy <- y,
        cz <- z, do: %Cube{x: cx, y: cy, z: cz}
  end

  def grid_search(%HyperBounds{x: x, y: y, z: z, w: w}) do
    for cx <- x,
        cy <- y,
        cz <- z,
        cw <- w,
        do: %HyperCube{x: cx, y: cy, z: cz, w: cw}
  end

  def neighbors(%Cube{x: x, y: y, z: z}) do
    for nx <- x - 1 .. x + 1,
        ny <- y - 1 .. y + 1,
        nz <- z - 1 .. z + 1,
        nx != x || ny != y || nz != z,
        do: %Cube{x: nx, y: ny, z: nz}
  end

  def neighbors(%HyperCube{x: x, y: y, z: z, w: w}) do
    for nx <- x - 1 .. x + 1,
        ny <- y - 1 .. y + 1,
        nz <- z - 1 .. z + 1,
        nw <- w - 1 .. w + 1,
        nx != x || ny != y || nz != z || nw != w,
        do: %HyperCube{x: nx, y: ny, z: nz, w: nw}
  end

  def find_bounds(state, dims) do
    cubes =
      state
      |> Enum.filter(&elem(&1, 1))
      |> Enum.map(&elem(&1, 0))

    xs = cubes |> Enum.map(& &1.x) |> Enum.sort()
    ys = cubes |> Enum.map(& &1.y) |> Enum.sort()
    zs = cubes |> Enum.map(& &1.z) |> Enum.sort()

    case dims do
      3 ->
        %Bounds{x: to_range(xs), y: to_range(ys), z: to_range(zs)}
      4 ->
        ws = cubes |> Enum.map(& &1.w) |> Enum.sort()
        %HyperBounds{x: to_range(xs), y: to_range(ys), z: to_range(zs), w: to_range(ws)}
    end
  end

  def to_range(ints) do
    Range.new(List.first(ints) - 1, List.last(ints) + 1)
  end

  def solution1(input) do
    input
    |> initialize(3)
    |> step(3, 6)
  end

  @doc """
  --- Part Two ---
  For some reason, your simulated results don't match what the experimental energy source engineers expected.
  Apparently, the pocket dimension actually has four spatial dimensions, not three.

  The pocket dimension contains an infinite 4-dimensional grid. At every integer 4-dimensional coordinate
  (x,y,z,w), there exists a single cube (really, a hypercube) which is still either active or inactive.

  Each cube only ever considers its neighbors: any of the 80 other cubes where any of their coordinates differ by
  at most 1. For example, given the cube at x=1,y=2,z=3,w=4, its neighbors include the cube at x=2,y=2,z=3,w=3,
  the cube at x=0,y=2,z=3,w=4, and so on.

  The initial state of the pocket dimension still consists of a small flat region of cubes. Furthermore, the same
  rules for cycle updating still apply: during each cycle, consider the number of active neighbors of each cube.

  For example, consider the same initial state as in the example above. Even though the pocket dimension is
  4-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial
  state defines a 3x3x1x1 region of the 4-dimensional space.)

  Simulating a few cycles from this initial state produces the following configurations, where the result of each
  cycle is shown layer-by-layer at each given z and w coordinate:
  """

  def solution2(input) do
    input
    |> initialize(4)
    |> step(4, 6)
  end

  def sample_input do
    """
    .#.
    ..#
    ###
    """
  end

  def real_input do
    @real_input
  end
end
