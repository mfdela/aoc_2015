defmodule Aoc.Day15 do
  def part1(args) do
    args
    |> parse_input()
    |> find_best_score()
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_best_score(500)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_ingredient/1)
  end

  def parse_ingredient(line) do
    [name, rest] =
      line
      |> String.split(": ", trim: true)

    [capacity, durability, flavor, texture, calories] =
      rest
      |> String.split(", ", trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&List.last/1)
      |> Enum.map(&String.to_integer/1)

    {name, capacity, durability, flavor, texture, calories}
  end

  def find_best_score(ingredients, calories_limit \\ nil, total_teaspoons \\ 100) do
    cookies =
      generate_combinations(length(ingredients), total_teaspoons)
      |> Enum.map(&Enum.zip(&1, ingredients))
      |> Enum.map(&calculate_score/1)
      |> Enum.map(&Enum.zip/1)
      |> Enum.map(fn scores ->
        Enum.map(scores, fn score -> max(Tuple.to_list(score) |> Enum.sum(), 0) end)
      end)

    calories_cookies =
      case calories_limit do
        nil ->
          cookies

        _ ->
          cookies
          |> Enum.filter(fn scores -> Enum.at(scores, -1) == calories_limit end)
      end

    calories_cookies
    |> Enum.map(&Enum.drop(&1, -1))
    |> Enum.map(&Enum.product/1)
    |> Enum.max()
  end

  # Generate all non-negative integer combinations that sum to 'remaining'
  defp generate_combinations(1, remaining), do: [[remaining]]

  defp generate_combinations(n, remaining) do
    for i <- 0..remaining,
        rest <- generate_combinations(n - 1, remaining - i) do
      [i | rest]
    end
  end

  def calculate_score(ingredients) do
    ingredients
    |> Enum.map(fn {amount, {_, capacity, durability, flavor, texture, calories}} ->
      [
        capacity * amount,
        durability * amount,
        flavor * amount,
        texture * amount,
        calories * amount
      ]
    end)
  end
end
