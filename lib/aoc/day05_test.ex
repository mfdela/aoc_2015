defmodule Aoc.Day05Test do
  use ExUnit.Case

  import Elixir.Aoc.Day05

  def test_input() do
    """
    ugknbfddgicrmopn
    aaa
    jchzalrnumimnmhp
    haegwjzuvuyypxyu
    dvszwmarrgswjxmb
    """
  end

  def test_input2() do
    """
    qjhvhtzxzqqjkmpb
    xxyxx
    uurcxstgmygtbstg
    ieodomkazucvgmuy
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 2
  end

  test "part2" do
    input = test_input2()
    result = part2(input)

    assert result == 2
  end
end
