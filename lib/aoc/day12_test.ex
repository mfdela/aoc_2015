defmodule Aoc.Day12Test do
  use ExUnit.Case

  import Elixir.Aoc.Day12

  def test_input() do
    "[1,{\"c\":\"red\",\"b\":2},3]"
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 6
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 4
  end
end
