defmodule Aoc.Day23Test do
  use ExUnit.Case

  import Elixir.Aoc.Day23

  def test_input() do
    """
    inc a
    jio a, +2
    tpl a
    inc a
    """
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
