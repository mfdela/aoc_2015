defmodule Aoc.Day02Test do
  use ExUnit.Case

  import Elixir.Aoc.Day02

  def test_input() do
    """
    2x3x4
    1x1x10
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 101
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 48
  end
end
