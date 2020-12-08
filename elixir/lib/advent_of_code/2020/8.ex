defmodule AdventOfCode.Y2020.D8 do
  @moduledoc """
  --- Day 8: Handheld Halting ---
  Your flight to the major airline hub reaches cruising altitude without incident. While you consider checking the
  in-flight menu for one of those drinks that come with a little umbrella, you are interrupted by the kid sitting
  next to you.

  Their handheld game console won't turn on! They ask if you can take a look.

  You narrow the problem down to a strange infinite loop in the boot code (your puzzle input) of the device. You
  should be able to fix it, but first you need to be able to run the code in isolation.

  The boot code is represented as a text file with one instruction per line of text. Each instruction consists of
  an operation (acc, jmp, or nop) and an argument (a signed number like +4 or -20).

  acc increases or decreases a single global value called the accumulator by the value given in the argument. For
  example, acc +7 would increase the accumulator by 7. The accumulator starts at 0. After an acc instruction, the
  instruction immediately below it is executed next. jmp jumps to a new instruction relative to itself. The next
  instruction to execute is found using the argument as an offset from the jmp instruction; for example, jmp +2
  would skip the next instruction, jmp +1 would continue to the instruction immediately below it, and jmp -20
  would cause the instruction 20 lines above to be executed next. nop stands for No OPeration - it does nothing.

  The instruction immediately below it is executed next.

  For example, consider the following program:

  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6

  These instructions are visited in this order:

  nop +0  | 1
  acc +1  | 2, 8(!)
  jmp +4  | 3
  acc +3  | 6
  jmp -3  | 7
  acc -99 |
  acc +1  | 4
  jmp -4  | 5
  acc +6  |

  First, the nop +0 does nothing. Then, the accumulator is increased from 0 to 1 (acc +1) and jmp +4 sets the next
  instruction to the other acc +1 near the bottom. After it increases the accumulator from 1 to 2, jmp -4
  executes, setting the next instruction to the only acc +3. It sets the accumulator to 5, and jmp -3 causes the
  program to continue back at the first acc +1.

  This is an infinite loop: with this sequence of jumps, the program will run forever. The moment the program
  tries to run any instruction a second time, you know it will never terminate.

  Immediately before the program would run an instruction a second time, the value in the accumulator is 5.

  Run your copy of the boot code. Immediately before any instruction is executed a second time, what value is in
  the accumulator?
  """
  alias AdventOfCode.Input
  @real_input Input.lines("2020/8.txt")

  @initial_state %{
    acc: 0, pointer: 0, instructions: [], visited: [], halted: false
  }

  def solution1(input) do
    instructions =
      Enum.map(input, fn line ->
        [opcode, number] = String.split(line)
        {opcode, String.to_integer(number)}
      end)

    run(instructions)
  end

  def run(instructions) do
    %{@initial_state | instructions: instructions}
    |> exec()
  end

  def exec(%{pointer: pointer, instructions: instructions} = state) when pointer >= length(instructions) do
    %{state | halted: true}
  end

  def exec(%{pointer: pointer, instructions: instructions, visited: visited} = state) do
    if pointer in visited do
      state
    else
      instruction = Enum.at(instructions, pointer)
      next = next_state(state, instruction)
      exec(%{next | visited: [pointer | visited]})
    end
  end

  def next_state(%{acc: acc, pointer: pointer} = state, {"acc", number}) do
    %{state | acc: acc + number,  pointer: pointer + 1}
  end

  def next_state(%{pointer: pointer} = state, {"nop", _number}) do
    %{state | pointer: pointer + 1}
  end

  def next_state(%{pointer: pointer} = state, {"jmp", offset}) do
    %{state | pointer: pointer + offset}
  end

  @doc """
  --- Part Two ---
  After some careful analysis, you believe that exactly one instruction is corrupted.

  Somewhere in the program, either a jmp is supposed to be a nop, or a nop is supposed to be a jmp. (No acc
  instructions were harmed in the corruption of this boot code.)

  The program is supposed to terminate by attempting to execute an instruction immediately after the last
  instruction in the file. By changing exactly one jmp or nop, you can repair the boot code and make it terminate
  correctly.

  For example, consider the same program from above:

  nop +0
  acc +1
  jmp +4
  acc +3
  jmp -3
  acc -99
  acc +1
  jmp -4
  acc +6

  If you change the first instruction from nop +0 to jmp +0, it would create a single-instruction infinite loop,
  never leaving that instruction. If you change almost any of the jmp instructions, the program will still
  eventually find another jmp instruction and loop forever.

  However, if you change the second-to-last instruction (from jmp -4 to nop -4), the program terminates! The
  instructions are visited in this order:

  nop +0  | 1
  acc +1  | 2
  jmp +4  | 3
  acc +3  |
  jmp -3  |
  acc -99 |
  acc +1  | 4
  nop -4  | 5
  acc +6  | 6

  After the last instruction (acc +6), the program terminates by attempting to run the instruction below the last
  instruction in the file. With this change, after the program terminates, the accumulator contains the value 8
  (acc +1, acc +1, acc +6).

  Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp). What is the
  value of the accumulator after the program terminates?
  """

  def solution2(input) do
    instructions =
      Enum.map(input, fn line ->
        [opcode, number] = String.split(line)
        {opcode, String.to_integer(number)}
      end)

    indexes =
      instructions
      |> Enum.with_index()
      |> Enum.filter(fn {{k, _}, _} -> k == "nop" || k == "jmp" end)
      |> Enum.map(&elem(&1, 1))

    halt_index =
      indexes
      |> Enum.find(fn i ->
        halt_state =
          instructions
          |> fix_instructions(i)
          |> run()

        halt_state.halted
      end)

    instructions
    |> fix_instructions(halt_index)
    |> run()
  end

  def fix_instructions(instructions, index) do
    fixed =
      instructions
      |> Enum.at(index)
      |> fix_instruction()

    List.replace_at(instructions, index, fixed)
  end

  def fix_instruction({"nop", n}), do: {"jmp", n}
  def fix_instruction({"jmp", n}), do: {"nop", n}

  def sample_input do
    [ "nop +0",
      "acc +1",
      "jmp +4",
      "acc +3",
      "jmp -3",
      "acc -99",
      "acc +1",
      "jmp -4",
      "acc +6",
    ]
  end

  def real_input do
    @real_input
  end
end
