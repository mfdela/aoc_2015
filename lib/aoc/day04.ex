defmodule Aoc.Day04 do
  def part1(args) do
    args |> parse_input() |> find_hash_with_prefix("00000")
  end

  def part2(args) do
    args |> parse_input() |> find_hash_with_prefix("000000")
  end

  def parse_input(input) do
    input |> String.trim()
  end

  defp md5_hash(string) do
    :crypto.hash(:md5, string) |> Base.encode16(case: :lower)
  end

  defp find_hash_with_prefix(input, prefix) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.find(fn n ->
      hash = md5_hash("#{input}#{n}")
      String.starts_with?(hash, prefix)
    end)
  end
end
