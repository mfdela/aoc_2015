defmodule Aoc.Day17 do
  def part1(args, litres \\ 150) do
    args
    |> parse_input()
    |> find_total_containers(litres)
    |> elem(0)
  end

  def part2(args, litres \\ 150) do
    with {_, containers_used} <-
           args
           |> parse_input()
           |> find_total_containers(litres),
         min <- containers_used |> Map.keys() |> Enum.min() do
      containers_used[min]
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer(String.trim(&1)))
  end

  def find_total_containers(containers, litres) do
    partitions = Aoc.Tools.Partition.partitions(litres, containers)

    containers_freq = Enum.frequencies(containers)

    Enum.reduce(partitions, {0, %{}}, fn partition, {count, matched_containers} ->
      partition_freq = Enum.frequencies(partition)

      subset =
        Enum.all?(partition_freq, fn {k, v} ->
          !is_nil(Map.get(containers_freq, k)) && Map.get(containers_freq, k) >= v
        end)

      case subset do
        false ->
          {count, matched_containers}

        true ->
          matching_containers =
            Enum.filter(containers_freq, fn {k, _v} -> !is_nil(partition_freq[k]) end)
            |> Map.new()

          way_to_arrange = find_containers(partition_freq, matching_containers)

          {count + way_to_arrange,
           Map.update(
             matched_containers,
             length(partition),
             way_to_arrange,
             &(&1 + way_to_arrange)
           )}
      end
    end)
  end

  def find_containers(partitions, matching_containers) do
    count =
      partitions
      |> Enum.map(fn {k, v} ->
        matching_containers[k] - v
      end)
      |> Enum.sum()

    Integer.pow(2, count)
  end
end
