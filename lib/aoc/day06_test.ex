defmodule Aoc.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc.Day06

  def test_input() do
    """
    turn on 0,0 through 999,999
    toggle 0,0 through 999,0
    turn off 499,499 through 500,500
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 998_996
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 1_001_996
  end
end
