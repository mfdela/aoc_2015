defmodule Aoc.Day10 do
  def part1(args, count \\ 40) do
    args
    |> String.trim()
    |> cycle_string(count)
    |> String.length()
  end

  def part2(args) do
    args
    |> String.trim()
    |> cycle_string(50)
    |> String.length()
  end

  def expand_string(string) do
    string
    |> String.graphemes()
    |> Enum.chunk_by(& &1)
    |> Enum.map(&{hd(&1), length(&1)})
  end

  def next_string(input) do
    input
    |> Enum.reduce("", fn {c, f}, acc ->
      acc <> "#{f}#{c}"
    end)
  end

  def cycle_string(string, 0), do: string

  def cycle_string(string, count) do
    string
    |> expand_string()
    |> next_string()
    |> cycle_string(count - 1)
  end
end
