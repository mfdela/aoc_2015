defmodule Aoc.Tools.Partition do
  # All partitions of n

  def partitions(0), do: [[]]
  def partitions(n) when n < 0, do: []

  def partitions(n) do
    partitions(n, n, [])
  end

  def partitions(n, must_contain) when is_list(must_contain) do
    partitions(n, n, must_contain)
  end

  # Partitions of n using parts of size at most max_part

  defp partitions(0, _max_part, _must_contain), do: [[]]
  defp partitions(_n, 0, _must_contain), do: []
  defp partitions(n, _max_part, _must_contain) when n < 0, do: []

  defp partitions(n, max_part, must_contain) do
    # Don't use max_part
    without = partitions(n, max_part - 1, must_contain)

    # Use at least one max_part
    with_part =
      case must_contain == [] || max_part in must_contain do
        false ->
          []

        true ->
          partitions(n - max_part, max_part, must_contain)
          |> Enum.map(fn p -> [max_part | p] end)
      end

    with_part ++ without
  end
end
