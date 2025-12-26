defmodule Aoc.Day24 do
  def part1(args) do
    args
    |> parse_input()
    |> divide_into_groups(3)
    |> Enum.map(&Enum.product/1)
    |> Enum.min()
  end

  def part2(args) do
    args
    |> parse_input()
    |> divide_into_groups(4)
    |> Enum.map(&Enum.product/1)
    |> Enum.min()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def exists_subgroup_weight?(weights, size, target_weight) do
    Aoc.Tools.Combinations.combinations(weights, size)
    |> Enum.any?(&(Enum.sum(&1) == target_weight))
  end

  def find_size_group1(weights, target_weight) do
    1..(length(weights) - 2)
    |> Enum.reduce_while(1, fn size, acc ->
      if exists_subgroup_weight?(weights, size, target_weight) do
        {:halt, size}
      else
        {:cont, acc}
      end
    end)
  end

  def divide_into_groups(weights, num_groups) do
    total_weight = Enum.sum(weights)
    group_weight = div(total_weight, num_groups)
    size_group1 = find_size_group1(weights, group_weight)

    Aoc.Tools.Combinations.combinations(weights, size_group1)
    |> Enum.filter(&(Enum.sum(&1) == group_weight))
  end
end
