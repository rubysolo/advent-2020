defmodule AdventOfCode.Input do
  @app_path Mix.Project.deps_path() |> Path.join("..")

  @spec raw(binary()) :: binary()
  def raw(input_path) do
    @app_path
    |> Path.join("priv/inputs/#{input_path}")
    |> File.read!()
  end

  @spec lines(binary()) :: list(binary())
  def lines(input_path) do
    input_path
    |> raw()
    |> String.split("\n", trim: true)
  end

  @spec list_of_integers(binary()) :: list(integer())
  def list_of_integers(input_path) do
    input_path
    |> lines()
    |> Enum.map(&String.to_integer/1)
  end

  @spec get_input(binary(), binary(), binary()) :: {:ok, binary()} | :error
  def get_input(session, year, day) do
    start_applications()
    resp = :httpc.request(:get, {"#{url(year, day)}/input", [cookie(session)]}, [], [])

    case resp do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} -> {:ok, body}
      _ -> :error
    end
  end

  defp start_applications do
    :ok = Application.ensure_started(:inets)
    :ok = Application.ensure_started(:crypto)
    :ok = Application.ensure_started(:asn1)
    :ok = Application.ensure_started(:public_key)
    :ok = Application.ensure_started(:ssl)
  end

  defp url(year, day), do: to_charlist("https://adventofcode.com/#{year}/day/#{day}")
  defp cookie(session), do: {'Cookie', to_charlist("session=#{session}")}
end
