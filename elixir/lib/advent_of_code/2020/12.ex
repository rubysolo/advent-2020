defmodule AdventOfCode.Y2020.D12 do
  @moduledoc """
  --- Day 12: Rain Risk ---
  Your ferry made decent progress toward the island, but the storm came in faster than anyone expected. The ferry
  needs to take evasive actions!

  Unfortunately, the ship's navigation computer seems to be malfunctioning; rather than giving a route directly to
  safety, it produced extremely circuitous instructions. When the captain uses the PA system to ask if anyone can
  help, you quickly volunteer.

  The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with
  integer input values. After staring at them for a few minutes, you work out what they probably mean:

  Action N means to move north by the given value.
  Action S means to move south by the given value.
  Action E means to move east by the given value.
  Action W means to move west by the given value.
  Action L means to turn left the given number of degrees.
  Action R means to turn right the given number of degrees.
  Action F means to move forward by the given value in the direction the ship is currently facing.

  The ship starts by facing east. Only the L and R actions change the direction the ship is facing. (That is, if
  the ship is facing east and the next instruction is N10, the ship would move north 10 units, but would still
  move east if the following action were F.)

  For example:

  F10
  N3
  F7
  R90
  F11

  These instructions would be handled as follows:

  F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
  N3 would move the ship 3 units north to east 10, north 3.
  F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
  R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
  F11 would move the ship 11 units south to east 17, south 8.

  At the end of these instructions, the ship's Manhattan distance (sum of the absolute values of its east/west
  position and its north/south position) from its starting position is 17 + 8 = 25.

  Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the
  ship's starting position?
  """
  alias AdventOfCode.Input
  @real_input Input.lines("2020/12.txt")

  defmodule State do
    defstruct [:x, :y, :dir]
  end

  def solution1(instructions) do
    final_state =
      instructions
      |> Enum.map(&parse_instruction/1)
      |> Enum.reduce(%State{x: 0, y: 0, dir: 0}, &update_state/2)

    abs(final_state.x) + abs(final_state.y)
  end

  def parse_instruction(<<code, count::binary>>) do
    {to_string([code]), String.to_integer(count)}
  end

  def update_state(instruction, %State{} = state) do
    do_update_state(instruction, state)
  end

  def do_update_state({"L", count}, %State{dir: dir} = state) do
    %{state | dir: rem(dir + count, 360)}
  end

  def do_update_state({"R", count}, %State{dir: dir} = state) do
    %{state | dir: rem(dir - count, 360)}
  end

  def do_update_state({"N", count}, %State{y: y} = state) do
    %{state | y: y - count}
  end

  def do_update_state({"S", count}, %State{y: y} = state) do
    %{state | y: y + count}
  end

  def do_update_state({"W", count}, %State{x: x} = state) do
    %{state | x: x - count}
  end

  def do_update_state({"E", count}, %State{x: x} = state) do
    %{state | x: x + count}
  end

  def do_update_state({"F", count}, %State{dir: dir} = state) do
    direction = degrees_to_direction(dir)
    update_state({direction, count}, state)
  end

  def degrees_to_direction(0), do: "E"
  def degrees_to_direction(90), do: "N"
  def degrees_to_direction(180), do: "W"
  def degrees_to_direction(270), do: "S"
  def degrees_to_direction(-90), do: "S"
  def degrees_to_direction(-180), do: "W"
  def degrees_to_direction(-270), do: "N"

  @doc """
  --- Part Two ---
  Before you can give the destination to the captain, you realize that the actual action meanings were printed on
  the back of the instructions the whole time.

  Almost all of the actions indicate how to move a waypoint which is relative to the ship's position:

  Action N means to move the waypoint north by the given value.
  Action S means to move the waypoint south by the given value.
  Action E means to move the waypoint east by the given value.
  Action W means to move the waypoint west by the given value.
  Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
  Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
  Action F means to move forward to the waypoint a number of times equal to the given value.

  The waypoint starts 10 units east and 1 unit north relative to the ship. The waypoint is relative to the ship;
  that is, if the ship moves, the waypoint moves with it.

  For example, using the same instructions as above:

  F10 moves the ship to the waypoint 10 times (a total of 100 units east and 10 units north), leaving the ship at east 100, north 10. The waypoint stays 10 units east and 1 unit north of the ship.
  N3 moves the waypoint 3 units north to 10 units east and 4 units north of the ship. The ship remains at east 100, north 10.
  F7 moves the ship to the waypoint 7 times (a total of 70 units east and 28 units north), leaving the ship at east 170, north 38. The waypoint stays 10 units east and 4 units north of the ship.
  R90 rotates the waypoint around the ship clockwise 90 degrees, moving it to 4 units east and 10 units south of the ship. The ship remains at east 170, north 38.
  F11 moves the ship to the waypoint 11 times (a total of 44 units east and 110 units south), leaving the ship at east 214, south 72. The waypoint stays 4 units east and 10 units south of the ship.
  After these operations, the ship's Manhattan distance from its starting position is 214 + 72 = 286.

  Figure out where the navigation instructions actually lead. What is the Manhattan distance between that location
  and the ship's starting position?
  """

  defmodule WaypointState do
    defstruct [:sx, :sy, :wx, :wy]
  end

  def solution2(instructions) do
    final_state =
      instructions
      |> Enum.map(&parse_instruction/1)
      |> Enum.reduce(%WaypointState{sx: 0, sy: 0, wx: 10, wy: -1}, &waypoint/2)

    abs(final_state.sx) + abs(final_state.sy)
  end

  def waypoint(instruction, %WaypointState{} = state) do
    do_waypoint(instruction, state)
  end

  def rotate_waypoint(x, y, 0), do: {x, y}
  def rotate_waypoint(x, y, 90), do: {y, x * -1}
  def rotate_waypoint(x, y, 180), do: {x * -1, y * -1}
  def rotate_waypoint(x, y, 270), do: {y * -1, x}
  def rotate_waypoint(x, y, -90), do: {y * -1, x}
  def rotate_waypoint(x, y, -180), do: {x * -1, y * -1}
  def rotate_waypoint(x, y, -270), do: {y, x * -1}

  def do_waypoint({"L", degrees}, %WaypointState{wx: x, wy: y} = state) do
    {x, y} = rotate_waypoint(x, y, rem(degrees, 360))
    %{state | wx: x, wy: y}
  end

  def do_waypoint({"R", degrees}, %WaypointState{wx: x, wy: y} = state) do
    {x, y} = rotate_waypoint(x, y, rem(degrees, 360) * -1)
    %{state | wx: x, wy: y}
  end

  def do_waypoint({"N", count}, %WaypointState{wy: y} = state) do
    %{state | wy: y - count}
  end

  def do_waypoint({"S", count}, %WaypointState{wy: y} = state) do
    %{state | wy: y + count}
  end

  def do_waypoint({"W", count}, %WaypointState{wx: x} = state) do
    %{state | wx: x - count}
  end

  def do_waypoint({"E", count}, %WaypointState{wx: x} = state) do
    %{state | wx: x + count}
  end

  def do_waypoint({"F", count}, %WaypointState{sx: sx, sy: sy, wx: wx, wy: wy} = state) do
    %{state | sx: sx + (count * wx), sy: sy + (count * wy)}
  end

  def sample_input do
    [
      "F10",
      "N3",
      "F7",
      "R90",
      "F11",
    ]
  end

  def real_input do
    @real_input
  end
end
