defmodule Aoc.Day19 do
  def part1(args) do
    args
    |> parse_input()
    |> do_replacements()
    |> Enum.count()
  end

  def part2(args) do
    # {replacements, molecule} =
    args
    |> parse_input()
    |> astar_search()

    # solve_math_part2(molecule)
  end

  def parse_input(input) do
    [replacements, molecule] = String.split(input, "\n\n", trim: true)

    replacements =
      String.split(replacements, "\n")
      |> Enum.map(&String.split(&1, " => ", trim: true))
      |> Enum.map(&List.to_tuple/1)

    {replacements, molecule |> String.trim()}
  end

  def do_replacements({replacements, molecule}) do
    replacements
    |> Enum.reduce(MapSet.new(), fn {from, to}, new_strings ->
      case String.contains?(molecule, from) do
        false -> []
        true -> replace_each_occurrence(molecule, from, to)
      end
      |> Enum.into(new_strings)
    end)
  end

  def replace_each_occurrence(string, pattern, replacement) do
    Regex.scan(~r/#{Regex.escape(pattern)}/, string, return: :index)
    |> List.flatten()
    |> Enum.map(fn {pos, len} ->
      String.slice(string, 0, pos) <>
        replacement <>
        String.slice(string, pos + len, String.length(string))
    end)
  end

  def solve_math_part2(molecule) do
    # Rn and Ar act like parentheses
    # Y acts like a comma separator
    # Each production step adds atoms
    # Count all atoms (uppercase letters, which represent element symbols)
    atoms = Regex.scan(~r/[A-Z]/, molecule) |> length()

    # Count structural markers
    rn_count = Regex.scan(~r/Rn/, molecule) |> length()
    ar_count = Regex.scan(~r/Ar/, molecule) |> length()
    y_count = Regex.scan(~r/Y/, molecule) |> length()

    # Apply the formula
    atoms - rn_count - ar_count - 2 * y_count - 1
  end

  defp astar_search({replacements, target}) do
    # Priority queue: {priority, molecule, steps}
    # Priority = steps + heuristic (molecule length as estimate to "e")
    initial_priority = String.length(target)
    pq = [{initial_priority, target, 0}]

    # Cache: molecule -> best steps to reach it
    cache = %{target => 0}

    astar_loop(pq, cache, replacements)
  end

  defp astar_loop([], _cache, _replacements), do: :not_found

  defp astar_loop(pq, cache, replacements) do
    # Get the entry with minimum priority
    [{_priority, molecule, steps} | pq_rest] = Enum.sort_by(pq, fn {p, _, _} -> p end)

    # Check if we reached "e"
    if molecule == "e" do
      steps
    else
      # Skip if we've found a better path to this molecule
      if Map.get(cache, molecule, :infinity) < steps do
        astar_loop(pq_rest, cache, replacements)
      else
        # Try all reverse replacements
        {new_pq, new_cache} =
          apply_astar_replacements(molecule, steps, replacements, pq_rest, cache)

        astar_loop(new_pq, new_cache, replacements)
      end
    end
  end

  defp apply_astar_replacements(molecule, steps, replacements, pq, cache) do
    Enum.reduce(replacements, {pq, cache}, fn {from, to}, {pq_acc, cache_acc} ->
      find_and_replace_astar(molecule, to, from, steps + 1, pq_acc, cache_acc)
    end)
  end

  defp find_and_replace_astar(molecule, pattern, replacement, new_steps, pq, cache) do
    length = String.length(pattern)
    max_pos = String.length(molecule) - length

    0..max_pos
    |> Enum.reduce({pq, cache}, fn pos, {pq_acc, cache_acc} ->
      if String.slice(molecule, pos, length) == pattern do
        new_molecule =
          String.slice(molecule, 0, pos) <>
            replacement <>
            String.slice(molecule, pos + length, String.length(molecule))

        # Only add if we haven't seen it or found a better path
        cached_steps = Map.get(cache_acc, new_molecule, :infinity)

        if new_steps < cached_steps do
          # Heuristic: steps + molecule length (estimate distance to "e")
          priority = new_steps + String.length(new_molecule)
          new_pq = [{priority, new_molecule, new_steps} | pq_acc]
          new_cache = Map.put(cache_acc, new_molecule, new_steps)
          {new_pq, new_cache}
        else
          {pq_acc, cache_acc}
        end
      else
        {pq_acc, cache_acc}
      end
    end)
  end
end
