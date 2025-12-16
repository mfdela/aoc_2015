defmodule Aoc.Day10Test do
  use ExUnit.Case

  import Elixir.Aoc.Day10

  def test_input() do
    "1"
  end

  test "part1" do
    input = test_input()
    result = part1(input, 5)

    assert result == 6
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result
  end
end
