defmodule Aoc.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc.Day03

  def test_input() do
    """
    ^v^v^v^v^v
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 11
  end
end
