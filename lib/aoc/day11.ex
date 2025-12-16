defmodule Aoc.Day11 do
  def part1(args) do
    args
    |> String.to_charlist()
    |> cycle()
    |> List.to_string()
  end

  def part2(args) do
    args
    |> part1()
    |> String.to_charlist()
    |> cycle()
    |> List.to_string()
  end

  def increment_by_1(charlist) do
    charlist
    |> Enum.reverse()
    |> Enum.reduce({[], 1}, fn c, {inc_list, curry} ->
      if curry == 0 do
        {inc_list ++ [c], 0}
      else
        case c do
          122 -> {inc_list ++ [97], 1}
          _ -> {inc_list ++ [c + 1], 0}
        end
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  def is_valid_password?(charlist) do
    Enum.all?(charlist, fn c -> c != 105 && c != 108 && c != 111 end) &&
      repeated_pairs?(charlist) &&
      three_straight?(charlist)
  end

  def repeated_pairs?(charlist) do
    {_, repeats} =
      charlist
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce({0, 0}, fn [c1, c2], {last_char, count} ->
        case c1 == c2 && c1 != last_char do
          false -> {last_char, count}
          true -> {c1, count + 1}
        end
      end)

    repeats >= 2
  end

  def three_straight?(charlist) do
    charlist
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.reduce_while(false, fn [c1, c2, c3], found ->
      case c3 == c2 + 1 && c2 == c1 + 1 do
        false -> {:cont, found}
        true -> {:halt, true}
      end
    end)
  end

  def cycle(charlist) do
    next_pw =
      charlist
      |> increment_by_1()

    case is_valid_password?(next_pw) do
      false -> cycle(next_pw)
      true -> next_pw
    end
  end
end
