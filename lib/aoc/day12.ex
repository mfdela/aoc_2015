defmodule Aoc.Day12 do
  def part1(args) do
    with {:ok, map} <- parse_input(args) do
      add_numbers(map)
    end
  end

  def part2(args) do
    with {:ok, map} <- parse_input(args) do
      add_numbers(map, true)
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> Jason.decode()
  end

  def add_numbers(object, ignore_red \\ false)

  def add_numbers(object, _ignore_red)
      when is_integer(object),
      do: object

  def add_numbers(object, _ignore_red) when is_binary(object), do: 0

  def add_numbers(object, ignore_red)
      when is_list(object), do: Enum.sum_by(object, &add_numbers(&1, ignore_red))

  def add_numbers(object, ignore_red) when is_map(object) do
    values =
      object
      |> Map.values()

    case ignore_red == true && Enum.any?(values, &(&1 == "red")) do
      false -> Enum.sum_by(values, &add_numbers(&1, ignore_red))
      true -> 0
    end
  end
end
