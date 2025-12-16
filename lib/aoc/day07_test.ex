defmodule Aoc.Day07Test do
  use ExUnit.Case

  import Elixir.Aoc.Day07

  def test_input() do
    """
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    d AND g -> a
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 64
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
