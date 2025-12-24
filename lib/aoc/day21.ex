defmodule Aoc.Day21.Item do
  defstruct [:name, :cost, :damage, :armor]
end

defmodule Aoc.Day21 do
  def items do
    %{
      weapons: [
        %Aoc.Day21.Item{name: "Dagger", cost: 8, damage: 4, armor: 0},
        %Aoc.Day21.Item{name: "Shortsword", cost: 10, damage: 5, armor: 0},
        %Aoc.Day21.Item{name: "Warhammer", cost: 25, damage: 6, armor: 0},
        %Aoc.Day21.Item{name: "Longsword", cost: 40, damage: 7, armor: 0},
        %Aoc.Day21.Item{name: "Greataxe", cost: 74, damage: 8, armor: 0}
      ],
      armor: [
        %Aoc.Day21.Item{name: "Leather", cost: 13, damage: 0, armor: 1},
        %Aoc.Day21.Item{name: "Chainmail", cost: 31, damage: 0, armor: 2},
        %Aoc.Day21.Item{name: "Splintmail", cost: 53, damage: 0, armor: 3},
        %Aoc.Day21.Item{name: "Bandedmail", cost: 75, damage: 0, armor: 4},
        %Aoc.Day21.Item{name: "Platemail", cost: 102, damage: 0, armor: 5}
      ],
      rings: [
        %Aoc.Day21.Item{name: "Damage +1", cost: 25, damage: 1, armor: 0},
        %Aoc.Day21.Item{name: "Damage +2", cost: 50, damage: 2, armor: 0},
        %Aoc.Day21.Item{name: "Damage +3", cost: 100, damage: 3, armor: 0},
        %Aoc.Day21.Item{name: "Defense +1", cost: 20, damage: 0, armor: 1},
        %Aoc.Day21.Item{name: "Defense +2", cost: 40, damage: 0, armor: 2},
        %Aoc.Day21.Item{name: "Defense +3", cost: 80, damage: 0, armor: 3}
      ]
    }
  end

  def part1(args) do
    boss =
      args
      |> parse_input()

    generate_limited_gears_combinations()
    |> Enum.map(&calculate_gears_stats(&1))
    |> Enum.map(fn {cost, damage, armor} ->
      {cost, player_win?({100, damage, armor}, boss)}
    end)
    |> Enum.filter(fn {_, result} -> result == true end)
    |> Enum.min_by(fn {cost, _} -> cost end)
    |> elem(0)
  end

  def part2(args) do
    boss =
      args
      |> parse_input()

    generate_limited_gears_combinations()
    |> Enum.map(&calculate_gears_stats(&1))
    |> Enum.map(fn {cost, damage, armor} ->
      {cost, player_win?({100, damage, armor}, boss)}
    end)
    |> Enum.filter(fn {_, result} -> result == false end)
    |> Enum.max_by(fn {cost, _} -> cost end)
    |> elem(0)
  end

  def parse_input(input) do
    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ": "))
      |> Enum.map(fn [key, value] -> {key, String.to_integer(value)} end)
      |> Enum.into(%{})

    %{hp: map["Hit Points"], damage: map["Damage"], armor: map["Armor"]}
  end

  def generate_limited_gears_combinations() do
    items = items()
    # All weapon options (must choose exactly 1)
    weapons = items.weapons

    # All armor options (0 or 1)
    armor_options = [[]] ++ Enum.map(items.armor, &[&1])

    # Rings: none, one, or two
    no_rings = [[]]
    single_rings = Enum.map(items.rings, &[&1])

    ring_pairs =
      for i <- 0..(length(items.rings) - 2),
          j <- (i + 1)..(length(items.rings) - 1) do
        [Enum.at(items.rings, i), Enum.at(items.rings, j)]
      end

    ring_options = no_rings ++ single_rings ++ ring_pairs
    # All combinations
    for weapon <- weapons,
        armor <- armor_options,
        rings <- ring_options do
      %{weapon: [weapon], armor: armor, rings: rings}
    end
  end

  def calculate_gears_stats(gears) do
    for {_type, items} <- gears, reduce: {0, 0, 0} do
      acc ->
        for item <- items, reduce: acc do
          inneracc ->
            {cost, damage, armor} = inneracc
            {cost + item.cost, damage + item.damage, armor + item.armor}
        end
    end
  end

  def player_win?(
        {player_hp, player_damage, player_armor},
        boss
      ) do
    damage_to_boss = max(1, player_damage - boss.armor)
    damage_to_player = max(1, boss.damage - player_armor)

    # Turns to kill
    # ceiling division
    turns_to_kill_boss = div(boss.hp + damage_to_boss - 1, damage_to_boss)
    turns_to_kill_player = div(player_hp + damage_to_player - 1, damage_to_player)

    # Player goes first, so player wins if they kill boss in same or fewer turns
    turns_to_kill_boss <= turns_to_kill_player
  end
end
