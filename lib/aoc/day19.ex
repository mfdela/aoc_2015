defmodule Aoc.Day19 do
  def part1(args) do
    args
    |> parse_input()
    |> do_replacements()
    |> Enum.count()
  end

  def part2(args) do
    {_replacements, molecule} =
      args
      |> parse_input()

    solve_math_part2(molecule)
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

  # def bfs_reverse({replacements, end_molecule}) do
  #   queue = :queue.from_list([{end_molecule, 0}])
  #   visited = MapSet.new([end_molecule])

  #   bfs_loop(replacements, visited, queue)
  # end

  # defp bfs_loop(replacements, visited, queue) do
  #   case :queue.out(queue) do
  #     {{:value, {molecule, steps}}, queue_rest} ->
  #       # Check if we reached "e"
  #       if molecule == "e" do
  #         steps
  #       else
  #         # Try all reverse replacements (replace RHS with LHS)
  #         {new_queue, new_visited} =
  #           apply_reverse_replacements(molecule, steps, replacements, queue_rest, visited)

  #         bfs_loop(replacements, new_visited, new_queue)
  #       end

  #     {:empty, _} ->
  #       :not_found
  #   end
  # end

  # defp apply_reverse_replacements(molecule, steps, replacements, queue, visited) do
  #   Enum.reduce(replacements, {queue, visited}, fn {from, to}, {q_acc, v_acc} ->
  #     # Find all positions where we can apply this reverse replacement
  #     find_and_replace_all(molecule, to, from, steps + 1, q_acc, v_acc)
  #   end)
  # end

  # defp find_and_replace_all(molecule, pattern, replacement, new_steps, queue, visited) do
  #   length = String.length(pattern)
  #   max_pos = String.length(molecule) - length

  #   0..max_pos
  #   |> Enum.reduce({queue, visited}, fn pos, {q_acc, v_acc} ->
  #     if String.slice(molecule, pos, length) == pattern do
  #       # Found a match, create new molecule
  #       new_molecule =
  #         String.slice(molecule, 0, pos) <>
  #           replacement <>
  #           String.slice(molecule, pos + length, String.length(molecule))

  #       # Add to queue if not visited
  #       if new_molecule in v_acc do
  #         {q_acc, v_acc}
  #       else
  #         {
  #           :queue.in({new_molecule, new_steps}, q_acc),
  #           MapSet.put(v_acc, new_molecule)
  #         }
  #       end
  #     else
  #       {q_acc, v_acc}
  #     end
  #   end)
  # end
end
