defmodule Aoc.Day23 do
  def part1(args) do
    args
    |> parse_input()
    |> run_program(%{a: 0, b: 0})
    |> Map.get(:b)
  end

  def part2(args) do
    args
    |> parse_input()
    |> run_program(%{a: 1, b: 0})
    |> Map.get(:b)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&parse_instruction/1)
    |> Enum.with_index()
    |> Enum.map(fn {instruction, offset} -> {offset, instruction} end)
    |> Map.new()
  end

  def parse_instruction(instruction) do
    case instruction do
      [opcode, arg1] when opcode == "jmp" ->
        {String.to_atom(opcode), String.to_integer(arg1), nil}

      [opcode, arg1] ->
        {String.to_atom(opcode), String.to_atom(arg1), nil}

      [opcode, arg1, arg2] ->
        {String.to_atom(opcode), String.to_atom(String.replace(arg1, ",", "")),
         String.to_integer(arg2)}
    end
  end

  def instructions_set do
    [
      %{
        :opcode => :hlf,
        :operation => fn memory, offset, arg, _arg2 ->
          {set_register(memory, arg, div(memory[arg], 2)), offset + 1}
        end
      },
      %{
        :opcode => :tpl,
        :operation => fn memory, offset, arg, _arg2 ->
          {set_register(memory, arg, memory[arg] * 3), offset + 1}
        end
      },
      %{
        :opcode => :inc,
        :operation => fn memory, offset, arg, _arg2 ->
          {set_register(memory, arg, memory[arg] + 1), offset + 1}
        end
      },
      %{
        :opcode => :jmp,
        :operation => fn memory, offset, arg, _arg2 ->
          {memory, offset + arg}
        end
      },
      %{
        :opcode => :jie,
        :operation => fn memory, offset, reg, jump_offset ->
          if rem(memory[reg], 2) == 0,
            do: {memory, offset + jump_offset},
            else: {memory, offset + 1}
        end
      },
      %{
        :opcode => :jio,
        :operation => fn memory, offset, reg, jump_offset ->
          if memory[reg] == 1, do: {memory, offset + jump_offset}, else: {memory, offset + 1}
        end
      }
    ]
  end

  def set_register(registers, reg, value) do
    Map.put(registers, reg, value)
  end

  def execute_instruction(memory, offset, {opcode, arg1, arg2}) do
    case instructions_set() |> Enum.find(&(&1[:opcode] == opcode)) do
      %{operation: operation} ->
        operation.(memory, offset, arg1, arg2)

      nil ->
        {:error, :invalid_instruction}
    end
  end

  def run_program(instructions, memory, offset \\ 0) do
    case instructions[offset] do
      nil ->
        memory

      instruction ->
        {next_memory, next_offset} = execute_instruction(memory, offset, instruction)
        run_program(instructions, next_memory, next_offset)
    end
  end
end
