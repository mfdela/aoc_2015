defmodule Aoc.Day14 do
  def part1(args, time \\ 2503) do
    args
    |> parse_input()
    |> Enum.map(&calculate_distance(&1, time))
    |> Enum.max_by(&elem(&1, 1))
    |> elem(1)
  end

  def part2(args, time \\ 2503) do
    args
    |> parse_input()
    |> compute_race(time)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, fn {name, speed, duration, rest}, acc ->
      Map.put(acc, name, {speed, duration, rest})
    end)
  end

  def parse_line(line) do
    [name, speed, duration, rest] =
      Regex.run(
        ~r/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds\./,
        line,
        capture: :all_but_first
      )

    {name, String.to_integer(speed), String.to_integer(duration), String.to_integer(rest)}
  end

  def calculate_distance({name, {speed, duration, rest}}, time) do
    full_cycles = div(time, duration + rest)
    remaining_time = rem(time, duration + rest)
    distance = full_cycles * speed * duration + min(remaining_time, duration) * speed
    {name, distance}
  end

  def compute_race(animals, time) do
    for t <- 1..time, reduce: %{} do
      acc ->
        distances = animals |> Enum.map(&calculate_distance(&1, t))
        max_distance = distances |> Enum.map(&elem(&1, 1)) |> Enum.max()

        winners = distances |> Enum.filter(fn {_, d} -> d == max_distance end)

        Enum.reduce(winners, acc, fn {name, _}, acc ->
          Map.update(acc, name, 1, &(&1 + 1))
        end)
    end
    |> Map.values()
    |> Enum.max()
  end
end
