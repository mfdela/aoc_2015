defmodule Aoc.Day20 do
  def part1(args) do
    args
    |> parse_input()
    |> find_house_present()
  end

  def part2(args) do
    args
    |> parse_input()
    |> find_house_present_k(50)
  end

  def parse_input(input) do
    input
    |> String.trim()
    |> String.to_integer()
  end

  def find_house_present(input) do
    house_presents(input, 1)
  end

  def house_presents(input, house_number) do
    presents = Aoc.Tools.Divisors.sum_divisors(house_number) * 10

    if presents >= input do
      house_number
    else
      house_presents(input, house_number + 1)
    end
  end

  def find_house_present_k(input, k) do
    house_presents_k(input, k, 1)
  end

  def house_presents_k(input, k, house_number) do
    threshold = ceil(house_number / k)
    presents = Aoc.Tools.Divisors.sum_divisors_k(house_number, threshold) * 11

    if house_number == 705_600 do
      IO.inspect(presents, label: "presents")
    end

    if presents >= input do
      house_number
    else
      house_presents_k(input, k, house_number + 1)
    end
  end
end
