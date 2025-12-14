defmodule Aoc.Day02 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(&calculate_wrapping_paper/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.map(&calculate_ribbon/1)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "x"))
    |> Enum.map(fn [l, w, h] ->
      {String.to_integer(l), String.to_integer(w), String.to_integer(h)}
    end)
  end

  def calculate_wrapping_paper(dimensions) do
    {l, w, h} = dimensions

    [l * w, w * h, h * l]
    |> Enum.map(&(&1 * 2))
    |> Enum.sum()
    |> Kernel.+(Enum.min([l * w, w * h, h * l]))
  end

  def calculate_ribbon(dimensions) do
    {l, w, h} = dimensions

    [l * 2 + w * 2, w * 2 + h * 2, h * 2 + l * 2]
    |> Enum.min()
    |> Kernel.+(l * w * h)
  end
end
