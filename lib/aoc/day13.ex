defmodule Aoc.Day13 do
  def part1(args) do
    {happiness_map, names} =
      args
      |> parse_input()

    evaluate_happiness(happiness_map, names)
  end

  def part2(args) do
    {happiness_map, names} =
      args
      |> parse_input()

    me_happiness =
      names
      |> MapSet.to_list()
      |> Enum.reduce(%{}, fn name, acc ->
        Map.put(acc, {name, "me"}, 0)
        |> Map.put({"me", name}, 0)
      end)

    evaluate_happiness(
      Map.merge(happiness_map, me_happiness),
      names |> MapSet.put("me")
    )
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({%{}, MapSet.new()}, fn {name1, name2, happiness}, {happiness_map, names} ->
      {Map.put(happiness_map, {name1, name2}, happiness),
       MapSet.put(names, name1) |> MapSet.put(name2)}
    end)
  end

  def parse_line(line) do
    [name1, gain_or_lose, happiness, name2] =
      Regex.run(
        ~r/(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\./,
        line,
        capture: :all_but_first
      )

    {name1, name2, String.to_integer(happiness) * if(gain_or_lose == "gain", do: 1, else: -1)}
  end

  def compute_happiness(seating_arrangement, happiness_map) do
    seating_arrangement
    |> Enum.concat([hd(seating_arrangement)])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(0, fn [person1, person2], acc ->
      acc + happiness_map[{person1, person2}] + happiness_map[{person2, person1}]
    end)
  end

  def evaluate_happiness(happiness_map, names) do
    names
    |> MapSet.to_list()
    |> permutations()
    |> Enum.map(&compute_happiness(&1, happiness_map))
    |> Enum.max()
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end
end
