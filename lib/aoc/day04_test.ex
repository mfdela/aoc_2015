defmodule Aoc.Day04Test do
  use ExUnit.Case

  import Elixir.Aoc.Day04

  def test_input() do
    """
    abcdef
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 609_043
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
