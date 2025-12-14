defmodule Aoc.Day01 do
  def part1(args) do
    {open, closed} =
      args
      |> parse_input()
      |> count_parens()

    open - closed
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_basement()
  end

  def parse_input(input) do
    input |> String.trim()
  end

  defp count_parens(string, open \\ 0, closed \\ 0)
  defp count_parens("(" <> rest, open, closed), do: count_parens(rest, open + 1, closed)
  defp count_parens(")" <> rest, open, closed), do: count_parens(rest, open, closed + 1)
  defp count_parens(<<_::utf8, rest::binary>>, open, closed), do: count_parens(rest, open, closed)
  defp count_parens("", open, closed), do: {open, closed}

  defp find_basement(string, pos \\ 0, floor \\ 0)
  defp find_basement(_, pos, -1), do: pos
  defp find_basement("(" <> rest, pos, floor), do: find_basement(rest, pos + 1, floor + 1)
  defp find_basement(")" <> rest, pos, floor), do: find_basement(rest, pos + 1, floor - 1)

  defp find_basement(<<_::utf8, rest::binary>>, pos, floor),
    do: find_basement(rest, pos, floor)

  defp find_basement("", _pos, _floor), do: :error
end
