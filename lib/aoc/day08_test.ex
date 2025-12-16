defmodule Aoc.Day08Test do
  use ExUnit.Case

  import Elixir.Aoc.Day08

  def test_input() do
    ~S(""
"abc"
"aaa\\\"aaa"
"\x27")
  end

  test "part1" do
    input = test_input()
    result = part1(input)

    # == 12
    assert result
  end

  test "part2" do
    input = test_input()
    result = part2(input)

    # == 19
    assert result
  end
end
