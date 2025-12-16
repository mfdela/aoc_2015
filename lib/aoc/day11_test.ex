defmodule Aoc.Day11Test do
  use ExUnit.Case

  import Elixir.Aoc.Day11

  def test_input() do
    "abcdefgh"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
