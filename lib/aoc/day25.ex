defmodule Aoc.Day25 do
  def part1(args) do
    [row, col] =
      args
      |> parse_input()

    k = find_diagonal_number_sequence(row, col)
    find_code(20_151_125, 252_533, 33_554_393, k)
  end

  def part2(args) do
    args
  end

  def parse_input(input) do
    string =
      input
      |> String.trim()

    Regex.run(~r/row (\d+), column (\d+)/, string, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)
  end

  def find_diagonal_number_sequence(row, col) do
    # Diagonal 1: position (1,1) = 1
    # Diagonal 2: positions (2,1)=2, (1,2)=3
    # Diagonal 3: positions (3,1)=4, (2,2)=5, (1,3)=6
    # Diagonal 4: positions (4,1)=7, (3,2)=8, (2,3)=9, (1,4)=10
    # Each diagonal d contains d elements
    # Diagonal d starts at position (d, 1) and goes up-right to (1, d)
    # The last element of diagonal d is at position (1, d) and has value d*(d+1)/2
    # Position (row, col) is on diagonal d = row + col - 1`
    # Within that diagonal, it's at offset col - 1 from the start
    diagonal = row + col - 1
    div((diagonal - 1) * diagonal, 2) + col - 1
  end

  def find_code(start, p1, p2, k) do
    # n1 = n0 * p1 mod p2, n2 = n1 * p1 mod p2, n3 = n2 * p1 mod p2, ...
    # nk = (n0 · p1^k) mod p2
    # modular exponentiation
    rem(start * pow_mod(p1, k, p2), p2)
  end

  defp pow_mod(base, exp, mod) do
    result_binary = :crypto.mod_pow(base, exp, mod)
    :binary.decode_unsigned(result_binary)
  end
end
