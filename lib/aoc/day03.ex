defmodule Aoc.Day03 do
  def part1(args) do
    args
    |> parse_input()
    |> deliver_presents()
    |> Map.keys()
    |> Enum.count()
  end

  def part2(args) do
    with {santa, santa_robot} <-
           args
           |> parse_input()
           |> deliver_presents_with_robot(),
         {santa_houses, santa_robot_houses} <-
           {santa |> Map.keys() |> MapSet.new(), santa_robot |> Map.keys() |> MapSet.new()} do
      MapSet.union(santa_houses, santa_robot_houses)
      |> MapSet.size()
    end
  end

  def parse_input(input) do
    input
    |> String.trim()
  end

  def deliver_presents(string), do: deliver_presents(string, {0, 0}, %{{0, 0} => 1})
  def deliver_presents("", _curr_pos, grid), do: grid

  def deliver_presents(<<dir::binary-size(1), rest::binary>>, santa_pos, grid) do
    new_pos = move(santa_pos, dir)
    deliver_presents(rest, new_pos, Map.update(grid, new_pos, 1, &(&1 + 1)))
  end

  def deliver_presents_with_robot(string),
    do: deliver_presents_with_robot(string, 0, {0, 0}, {0, 0}, %{{0, 0} => 1}, %{{0, 0} => 1})

  defp deliver_presents_with_robot("", _, _, _, grid1, grid2), do: {grid1, grid2}

  defp deliver_presents_with_robot(
         <<dir::binary-size(1), rest::binary>>,
         counter,
         santa_pos,
         robot_pos,
         santa_grid,
         robot_grid
       ) do
    if rem(counter, 2) == 0 do
      new_pos = move(santa_pos, dir)

      deliver_presents_with_robot(
        rest,
        counter + 1,
        new_pos,
        robot_pos,
        Map.update(santa_grid, new_pos, 1, &(&1 + 1)),
        robot_grid
      )
    else
      new_pos = move(robot_pos, dir)

      deliver_presents_with_robot(
        rest,
        counter + 1,
        santa_pos,
        new_pos,
        santa_grid,
        Map.update(robot_grid, new_pos, 1, &(&1 + 1))
      )
    end
  end

  defp move({x, y}, "^"), do: {x, y + 1}
  defp move({x, y}, "v"), do: {x, y - 1}
  defp move({x, y}, "<"), do: {x - 1, y}
  defp move({x, y}, ">"), do: {x + 1, y}
end
