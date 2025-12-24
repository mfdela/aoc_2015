defmodule Aoc.Tools.Combinations do
  def combinations(_list, 0), do: [[]]
  def combinations([], _k), do: []

  def combinations([h | t], k) do
    for(l <- combinations(t, k - 1), do: [h | l]) ++ combinations(t, k)
  end
end
