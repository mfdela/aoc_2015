defmodule Aoc.Tools.PowerSet do
  def power_set([]), do: [[]]

  def power_set([h | t]) do
    rest = power_set(t)
    rest ++ Enum.map(rest, fn subset -> [h | subset] end)
  end
end
