defmodule Aoc.Tools.Partition do
  # All partitions of n
  def partitions(0), do: [[]]
  def partitions(n) when n < 0, do: []

  def partitions(n) do
    partitions(n, n)
  end

  # Partitions of n using parts of size at most max_part
  defp partitions(0, _max_part), do: [[]]
  defp partitions(_n, 0), do: []
  defp partitions(n, _max_part) when n < 0, do: []

  defp partitions(n, max_part) do
    # Don't use max_part
    without = partitions(n, max_part - 1)

    # Use at least one max_part
    with_part =
      partitions(n - max_part, max_part)
      |> Enum.map(fn p -> [max_part | p] end)

    with_part ++ without
  end
end
