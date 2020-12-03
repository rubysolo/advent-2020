defmodule Mix.Tasks.Setup do
  @shortdoc "generate test and implementation stubs and download inputs"
  @moduledoc """
  Generate stub modules for test and implementation and download inputs for a day of Advent of Code
  """
  use Mix.Task

  def run([]) do
    # default to today (eastern time)
    {:ok, _} = Application.ensure_all_started(:tzdata)
    {:ok, now} = DateTime.now("America/New_York")

    unless now.month == 12, do: raise("it's not December yet, be patient.")

    run([now.year, now.day] |> Enum.map(&to_string/1))
  end

  def run([year, day]) do
    IO.puts("year: #{year}, day: #{day}")
    ensure_inputs_exist(year, day)
    ensure_stub_test_exists(year, day)
    ensure_stub_impl_exists(year, day)
  end

  defp app_path do
    Mix.Project.deps_path() |> Path.join("..")
  end

  defp ensure_inputs_exist(year, day) do
    filepath = Path.join([app_path(), "priv", "inputs", year, "#{day}.txt"])

    if File.exists?(filepath) do
      IO.puts("input #{filepath} already exists, skipping...")
    else
      cookie = Application.get_env(:advent_of_code, :session_cookie)
      IO.puts("input #{filepath} does not exist, downloading...")
      {:ok, input} = AdventOfCode.Input.get_input(cookie, year, day)
      write_content(filepath, input)
    end
  end

  defp ensure_stub_test_exists(year, day) do
    filepath = Path.join([app_path(), "test", "advent_of_code", year, "#{day}_test.exs"])

    if File.exists?(filepath) do
      IO.puts("test #{filepath} already exists, skipping...")
    else
      IO.puts("test #{filepath} does not exist, creating...")
      content = test_module(year, day)
      write_content(filepath, content)
    end
  end

  defp ensure_stub_impl_exists(year, day) do
    filepath = Path.join([app_path(), "lib", "advent_of_code", year, "#{day}.ex"])

    if File.exists?(filepath) do
      IO.puts("impl #{filepath} already exists, skipping...")
    else
      IO.puts("impl #{filepath} does not exist, creating...")
      content = implementation_module(year, day)
      write_content(filepath, content)
    end
  end

  defp write_content(filepath, content) do
    filepath
    |> Path.dirname()
    |> File.mkdir_p!()

    File.write!(filepath, content)
  end

  defp implementation_module(year, day) do
    """
    defmodule AdventOfCode.Y#{year}.D#{day} do
      alias AdventOfCode.Input
      @real_input Input.list_of_integers("#{year}/#{day}.txt")

      def solution1(input) do
      end

      def solution2(input) do
      end

      def sample_input do
        # copy/pasta here
        []
      end

      def real_input do
        @real_input
      end
    end
    """
  end

  defp test_module(year, day) do
    """
    defmodule AdventOfCode.Y#{year}.D#{day}Test do
      use ExUnit.Case

      alias AdventOfCode.Y#{year}.D#{day}

      describe "solution1" do
        test "works for sample input" do
          assert D#{day}.solution1(D#{day}.sample_input) == 0
        end

        @tag :skip
        test "works for real input" do
          assert D#{day}.solution1(D#{day}.real_input) == 0
        end
      end

      describe "solution2" do
        @tag :skip
        test "works for sample input" do
          assert D#{day}.solution2(D#{day}.sample_input) == 0
        end

        @tag :skip
        test "works for real input" do
          assert D#{day}.solution2(D#{day}.real_input) == 0
        end
      end
    end
    """
  end
end
