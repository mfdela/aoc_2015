defmodule Aoc.Tools.Divisors do
  def sum_divisors(0), do: 0

  def sum_divisors(n) do
    limit = n |> :math.sqrt() |> floor()

    1..limit
    |> Enum.reduce(0, fn i, total ->
      if rem(n, i) == 0 do
        total = total + i

        if i != div(n, i) do
          total + div(n, i)
        else
          total
        end
      else
        total
      end
    end)
  end

  def sum_divisors_k(0, _k), do: 0

  def sum_divisors_k(n, k) do
    limit = n |> :math.sqrt() |> floor()

    1..limit
    |> Enum.reduce(0, fn i, total ->
      if rem(n, i) == 0 do
        # Add i if it's greater than k
        total = if i >= k, do: total + i, else: total

        # Add n/i if it's different from i and greater than k
        if i != div(n, i) and div(n, i) >= k do
          total + div(n, i)
        else
          total
        end
      else
        total
      end
    end)
  end
end
