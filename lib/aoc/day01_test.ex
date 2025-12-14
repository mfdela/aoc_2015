defmodule Aoc.Day01Test do
  use ExUnit.Case

  import Elixir.Aoc.Day01

  def test_input() do
    """
    ()())
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == -1
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 5
  end
end
