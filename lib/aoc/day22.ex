defmodule Aoc.Day22 do
  def part1(args) do
    [boss_hp, boss_damage] =
      args
      |> parse_input()

    initial_state(boss_hp, boss_damage)
    |> simulate_game()
  end

  def part2(args) do
    [boss_hp, boss_damage] =
      args
      |> parse_input()

    initial_state(boss_hp, boss_damage)
    |> simulate_game(true)
  end

  def parse_input(input) do
    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ": "))
      |> Enum.map(fn [key, value] -> {key, String.to_integer(value)} end)
      |> Enum.into(%{})

    [map["Hit Points"], map["Damage"]]
  end

  def spells() do
    [
      %{
        :name => :magic_missile,
        :cost => 53,
        :effect => fn state -> %{state | boss_hp: state.boss_hp - 4} end
      },
      %{
        :name => :drain,
        :cost => 73,
        :effect => fn state ->
          %{state | hp: state.hp + 2, boss_hp: state.boss_hp - 2}
        end
      },
      %{
        :name => :shield,
        :cost => 113,
        :effect => fn state -> %{state | shield: 6} end
      },
      %{
        :name => :poison,
        :cost => 173,
        :effect => fn state -> %{state | poison: 6} end
      },
      %{
        :name => :recharge,
        :cost => 229,
        :effect => fn state -> %{state | recharge: 5} end
      }
    ]
  end

  def initial_state(boss_hp, boss_damage) do
    %{
      hp: 50,
      mana: 500,
      boss_hp: boss_hp,
      boss_damage: boss_damage,
      shield: 0,
      poison: 0,
      recharge: 0
    }
  end

  def evaluate_state(state) do
    state
    |> apply_effects()
    |> check_state()
  end

  def apply_effects(state) do
    state
    |> apply_shield()
    |> apply_poison()
    |> apply_recharge()
  end

  def apply_shield(state) do
    if state.shield > 0 do
      %{state | shield: state.shield - 1}
    else
      state
    end
  end

  def apply_poison(state) do
    if state.poison > 0 do
      %{state | boss_hp: state.boss_hp - 3, poison: state.poison - 1}
    else
      state
    end
  end

  def apply_recharge(state) do
    if state.recharge > 0 do
      %{state | mana: state.mana + 101, recharge: state.recharge - 1}
    else
      state
    end
  end

  def check_state(state) do
    cond do
      state.hp <= 0 -> {:lose, state}
      state.boss_hp <= 0 -> {:win, state}
      true -> {:continue, state}
    end
  end

  def can_cast?(state, spell) do
    # Check if we have enough mana
    has_mana = state.mana >= spell.cost

    # Check if effect spells are not already active
    not_active =
      case spell.name do
        :shield -> state.shield == 0
        :poison -> state.poison == 0
        :recharge -> state.recharge == 0
        _ -> true
      end

    has_mana and not_active
  end

  def cast(state, spell) do
    %{state | mana: state.mana - spell.cost}
    |> spell.effect.()
    |> check_state()
  end

  def boss_turn(state) do
    case evaluate_state(state) do
      {:continue, new_state} ->
        attack(new_state)
        |> check_state()

      other ->
        other
    end
  end

  def attack(state) do
    if state.shield > 0 do
      %{state | hp: state.hp - max(1, state.boss_damage - 7)}
    else
      %{state | hp: state.hp - max(1, state.boss_damage)}
    end
  end

  def simulate_game(state, hard \\ false) do
    game_loop(state, 0, hard, nil)
  end

  def game_loop(state, mana_spent, hard, best_win) do
    # Prune: if we've already spent more than our best win, stop exploring this branch
    if best_win != nil and mana_spent >= best_win do
      best_win
    else
      hard_state = if hard, do: %{state | hp: state.hp - 1}, else: state
      # Apply effects first to see the actual state at the start of player's turn
      case evaluate_state(hard_state) do
        {:win, _} ->
          # Boss died from effects (poison)
          min(mana_spent, best_win || mana_spent)

        {:lose, _} ->
          # Player died
          best_win

        {:continue, state_after_effects} ->
          # Get all castable spells based on state AFTER effects
          castable_spells =
            Enum.filter(spells(), fn spell -> can_cast?(state_after_effects, spell) end)

          if Enum.empty?(castable_spells) do
            # No valid spells to cast - player loses
            best_win
          else
            # Try each castable spell and explore all branches
            Enum.reduce(castable_spells, best_win, fn spell, current_best ->
              new_mana_spent = mana_spent + spell.cost

              # Prune: skip this spell if it already exceeds our best
              if current_best != nil and new_mana_spent >= current_best do
                current_best
              else
                # Cast spell and check if boss dies
                case cast(state_after_effects, spell) do
                  {:win, _} ->
                    # Boss died from spell
                    min(new_mana_spent, current_best || new_mana_spent)

                  {:lose, _} ->
                    # Player died
                    current_best

                  {:continue, state_after_cast} ->
                    # Boss turn happens
                    case boss_turn(state_after_cast) do
                      {:win, _} ->
                        # Boss died on their turn (poison damage)
                        min(new_mana_spent, current_best || new_mana_spent)

                      {:lose, _} ->
                        current_best

                      {:continue, new_state} ->
                        game_loop(new_state, new_mana_spent, hard, current_best)
                    end
                end
              end
            end)
          end
      end
    end
  end
end
