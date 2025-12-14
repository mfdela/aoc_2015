defmodule Aoc.Day05 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.filter(&nice_string?/1)
    |> Enum.count()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.filter(&nice_string2?/1)
    |> Enum.count()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  def nice_string?(string) do
    has_three_vowels =
      string
      |> String.graphemes()
      |> Enum.count(&(&1 in ["a", "e", "i", "o", "u"])) >= 3

    has_double_letter =
      string
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.any?(fn [a, b] -> a == b end)

    has_forbidden_strings =
      ["ab", "cd", "pq", "xy"]
      |> Enum.any?(&String.contains?(string, &1))

    has_three_vowels and has_double_letter and not has_forbidden_strings
  end

  def nice_string2?(string) do
    has_pair =
      string
      |> String.graphemes()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.with_index()
      |> Enum.any?(fn {[a, b], index} ->
        pair = "#{a}#{b}"
        remaining_string = String.slice(string, (index + 2)..-1//1)
        String.contains?(remaining_string, pair)
      end)

    has_repeat =
      string
      |> String.graphemes()
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.any?(fn [a, _, c] -> a == c end)

    has_pair and has_repeat
  end
end
