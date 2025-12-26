defmodule Aoc.Day22Test do
  use ExUnit.Case

  import Elixir.Aoc.Day22

  def test_input() do
    """
    Hit Points: 13
    Damage: 8
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 212
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
