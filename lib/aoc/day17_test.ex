defmodule Aoc.Day17Test do
  use ExUnit.Case

  import Elixir.Aoc.Day17

  def test_input() do
    """
     20
     15
     10
     5
     5
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 25)

    assert result == 4
  end

  test "part2" do
    input = test_input()
    result = part2(input, 25)

    assert result == 3
  end
end
