defmodule Aoc.Day06 do
  def part1(args) do
    args
    |> parse_input()
    |> execute_instructions(&execute_switch/2)
    |> count_lights_on()
  end

  def part2(args) do
    args
    |> parse_input()
    |> execute_instructions(&execute_brightness/2)
    |> count_brightness()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    {action, rest} =
      cond do
        String.starts_with?(line, "turn on") ->
          {:turn_on, String.trim_leading(line, "turn on ")}

        String.starts_with?(line, "turn off") ->
          {:turn_off, String.trim_leading(line, "turn off ")}

        String.starts_with?(line, "toggle") ->
          {:toggle, String.trim_leading(line, "toggle ")}
      end

    [from_x, from_y, _, to_x, to_y] =
      String.split(rest, " ", trim: true) |> Enum.flat_map(&String.split(&1, ","))

    {action, {String.to_integer(from_x), String.to_integer(from_y)},
     {String.to_integer(to_x), String.to_integer(to_y)}}
  end

  def execute_instructions(instructions, fun) do
    instructions
    |> Enum.reduce(%{}, &fun.(&1, &2))
  end

  def execute_switch({action, {from_x, from_y}, {to_x, to_y}}, grid) do
    for x <- from_x..to_x, y <- from_y..to_y, reduce: grid do
      acc ->
        case action do
          :turn_on ->
            Map.put(acc, {x, y}, true)

          :turn_off ->
            Map.put(acc, {x, y}, false)

          :toggle ->
            Map.update(acc, {x, y}, true, &(!&1))
        end
    end
  end

  def count_lights_on(grid) do
    grid
    |> Map.values()
    |> Enum.count(&(&1 == true))
  end

  def execute_brightness({action, {from_x, from_y}, {to_x, to_y}}, grid) do
    for x <- from_x..to_x, y <- from_y..to_y, reduce: grid do
      acc ->
        case action do
          :turn_on ->
            Map.update(acc, {x, y}, 1, &(&1 + 1))

          :turn_off ->
            case Map.get(acc, {x, y}, 0) do
              brightness when brightness <= 1 -> Map.delete(acc, {x, y})
              brightness -> Map.put(acc, {x, y}, brightness - 1)
            end

          :toggle ->
            Map.update(acc, {x, y}, 2, &(&1 + 2))
        end
    end
  end

  def count_brightness(grid) do
    grid
    |> Map.values()
    |> Enum.sum()
  end
end
