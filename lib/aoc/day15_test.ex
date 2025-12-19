defmodule Aoc.Day15Test do
  use ExUnit.Case

  import Elixir.Aoc.Day15

  def test_input() do
    """
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 62_842_880
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 57_600_000
  end
end
