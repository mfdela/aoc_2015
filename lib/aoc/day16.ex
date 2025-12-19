defmodule Aoc.Day16 do
  @ticker_tape %{
    children: 3,
    cats: 7,
    samoyeds: 2,
    pomeranians: 3,
    akitas: 0,
    vizslas: 0,
    goldfish: 5,
    trees: 3,
    cars: 2,
    perfumes: 1
  }

  def part1(args) do
    args
    |> parse_input()
    |> find_aunt()
    |> elem(0)
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_aunt2()
    |> elem(0)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  def parse_line(line) do
    [aunt, rest] =
      Regex.run(~r/Sue (\d+):\s+(.*)/, line, capture: :all_but_first)

    aunt_attributes =
      rest
      |> String.split(", ", trim: true)
      |> Enum.map(&parse_pair/1)
      |> Map.new()

    {String.to_integer(aunt), aunt_attributes}
  end

  def parse_pair(pair) do
    [key, value] =
      Regex.run(~r/(\w+): (\d+)/, pair, capture: :all_but_first)

    {String.to_atom(key), String.to_integer(value)}
  end

  def find_aunt(aunts) do
    # filter out all that are not equal to the ticker tape
    aunts
    |> Enum.find(fn {_, attributes} ->
      Enum.all?(attributes, fn {key, value} ->
        @ticker_tape[key] == value
      end)
    end)
  end

  def find_aunt2(aunts) do
    # filter out all that are not equal to the ticker tape
    aunts
    |> Enum.find(fn {_, attributes} ->
      Enum.all?(attributes, fn {key, value} ->
        case key do
          :cats -> @ticker_tape[key] < value
          :trees -> @ticker_tape[key] < value
          :pomeranians -> @ticker_tape[key] > value
          :goldfish -> @ticker_tape[key] > value
          _ -> @ticker_tape[key] == value
        end
      end)
    end)
  end
end
