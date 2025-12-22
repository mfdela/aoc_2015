defmodule Aoc.Day18 do
  def part1(args, cycles \\ 100) do
    {lights, rows, cols} =
      args
      |> parse_input()

    cycle(lights, rows, cols, cycles)
    |> MapSet.size()
  end

  def part2(args, cycles \\ 100) do
    {lights, rows, cols} =
      args
      |> parse_input()

    new_lights =
      Enum.reduce(
        [{0, 0}, {0, cols - 1}, {rows - 1, 0}, {rows - 1, cols - 1}],
        lights,
        fn corner, acc -> MapSet.put(acc, corner) end
      )

    cycle(new_lights, rows, cols, cycles, true)
    |> MapSet.size()
  end

  def parse_input(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {row, r} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {val, c} -> {{r, c}, val} end)
      end)

    rows = Enum.count(grid)

    cols =
      Enum.max_by(grid, fn row ->
        Enum.count(row)
      end)
      |> Enum.count()

    {grid
     |> List.flatten()
     |> Enum.filter(&(elem(&1, 1) == "#"))
     |> Enum.map(&elem(&1, 0))
     |> Enum.into(MapSet.new()), rows, cols}
  end

  def step(lights, rows, cols, stuck_corners) do
    new_lights =
      for r <- 0..(rows - 1), c <- 0..(cols - 1), reduce: MapSet.new() do
        acc ->
          neighbours = neighbours({r, c}, rows, cols)

          count = Enum.count(neighbours, &MapSet.member?(lights, &1))

          cond do
            MapSet.member?(lights, {r, c}) && (count == 2 || count == 3) ->
              MapSet.put(acc, {r, c})

            !MapSet.member?(lights, {r, c}) && count == 3 ->
              MapSet.put(acc, {r, c})

            true ->
              acc
          end
      end

    case stuck_corners do
      false ->
        new_lights

      true ->
        Enum.reduce(
          [{0, 0}, {0, cols - 1}, {rows - 1, 0}, {rows - 1, cols - 1}],
          new_lights,
          fn corner, acc -> MapSet.put(acc, corner) end
        )
    end
  end

  def neighbours({x, y}, rows, cols) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
    |> Enum.filter(fn {x, y} -> x >= 0 && x < rows && y >= 0 && y < cols end)
  end

  def cycle(lights, rows, cols, n, stuck_corners \\ false) do
    Enum.reduce(1..n, lights, fn _, acc -> step(acc, rows, cols, stuck_corners) end)
  end
end
