defmodule Aoc.Day19Test do
  use ExUnit.Case

  import Elixir.Aoc.Day19

  def test_input() do
    """
    H => HO
    H => OH
    O => HH

    HOH
    """
  end

  def test_input2() do
    """
    e => H
    e => O
    H => HO
    H => OH
    O => HH

    HOHOHO
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 6
  end
end
