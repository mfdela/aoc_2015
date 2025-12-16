defmodule Aoc.Day09Test do
  use ExUnit.Case

  import Elixir.Aoc.Day09

  def test_input() do
    """
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 605
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 982
  end
end
