defmodule Aoc.Day08 do
  def part1(args) do
    args
    |> parse_input()
    |> Enum.map(fn line ->
      literal_length(line) - memory_length(line)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> parse_input()
    |> Enum.map(fn line ->
      encoded_length(line) - literal_length(line)
    end)
    |> Enum.sum()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  # To get the literal string length (as written in the file)
  def literal_length(line) do
    String.length(line)
  end

  # To get the in-memory length (after escape sequences are processed)
  def memory_length(line) do
    Code.eval_string(line)
    |> elem(0)
    |> String.length()
  end

  def encoded_length(line) do
    Macro.to_string(quote do: unquote(line))
    |> String.length()
  end
end
