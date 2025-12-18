defmodule Aoc.Day13Test do
  use ExUnit.Case

  import Elixir.Aoc.Day13

  def test_input() do
    """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    assert result == 330
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    assert result == 286
  end
end
