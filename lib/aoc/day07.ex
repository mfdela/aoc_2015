defmodule Aoc.Day07 do
  import Bitwise

  def part1(args) do
    args
    |> parse_input()
    |> build_circuit()
    |> evaluate_circuit("a")
    |> elem(0)
  end

  def part2(args) do
    circuit =
      args
      |> parse_input()
      |> build_circuit()

    a =
      evaluate_circuit(circuit, "a")
      |> elem(0)

    Map.put(circuit, "b", a)
    |> evaluate_circuit("a")
    |> elem(0)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [operation, target] = String.split(line, " -> ")
    {parse_operation(operation), target}
  end

  defp parse_operation(op) do
    case String.split(op, " ", trim: true) do
      [value] ->
        parse_value(value)

      ["NOT", arg] ->
        {:not, parse_value(arg)}

      [left, "AND", right] ->
        {:and, parse_value(left), parse_value(right)}

      [left, "OR", right] ->
        {:or, parse_value(left), parse_value(right)}

      [left, "LSHIFT", amount] ->
        {:lshift, parse_value(left), String.to_integer(amount)}

      [left, "RSHIFT", amount] ->
        {:rshift, parse_value(left), String.to_integer(amount)}
    end
  end

  defp parse_value(val) do
    case Integer.parse(val) do
      {num, ""} -> num
      :error -> val
    end
  end

  def build_circuit(input) do
    input
    |> Enum.reduce(%{}, fn {operation, target}, circuit ->
      Map.put(circuit, target, operation)
    end)
  end

  def evaluate_circuit(circuit, wire), do: evaluate_circuit(circuit, wire, %{})

  def evaluate_circuit(_circuit, wire, cache) when is_integer(wire), do: {wire, cache}

  def evaluate_circuit(circuit, wire, cache) do
    # Check cache first
    if Map.has_key?(cache, wire) do
      {cache[wire], cache}
    else
      {result, new_cache} =
        case Map.fetch(circuit, wire) do
          {:ok, value} when is_integer(value) ->
            {value, cache}

          {:ok, value} when is_binary(value) ->
            evaluate_circuit(circuit, value, cache)

          {:ok, {:not, arg}} ->
            {val, cache1} = evaluate_circuit(circuit, arg, cache)
            {bnot(val), cache1}

          {:ok, {:and, left, right}} ->
            {left_val, cache1} = evaluate_circuit(circuit, left, cache)
            {right_val, cache2} = evaluate_circuit(circuit, right, cache1)

            {left_val &&& right_val, cache2}

          {:ok, {:or, left, right}} ->
            {left_val, cache1} = evaluate_circuit(circuit, left, cache)
            {right_val, cache2} = evaluate_circuit(circuit, right, cache1)
            {left_val ||| right_val, cache2}

          {:ok, {:lshift, left, amount}} ->
            {val, cache1} = evaluate_circuit(circuit, left, cache)
            {val <<< amount, cache1}

          {:ok, {:rshift, left, amount}} ->
            {val, cache1} = evaluate_circuit(circuit, left, cache)
            {val >>> amount, cache1}

          :error ->
            raise "Unknown wire: #{wire}"
        end

      # Store in cache
      {result, Map.put(new_cache, wire, result)}
    end
  end
end
