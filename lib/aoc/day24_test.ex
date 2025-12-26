defmodule Aoc.Day24Test do
  use ExUnit.Case

  import Elixir.Aoc.Day24

  def test_input() do
    """
    1
    2
    3
    4
    5
    7
    8
    9
    10
    11
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 99
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 44
  end
end
