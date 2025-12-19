defmodule Aoc.Day14Test do
  use ExUnit.Case

  import Elixir.Aoc.Day14

  def test_input() do
    """
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input, 1000)

    assert result == 1120
  end

  test "part2" do
    input = test_input()
    result = part2(input, 1000)

    assert result == 689
  end
end
