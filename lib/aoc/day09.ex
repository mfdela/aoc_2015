defmodule Aoc.Day09 do
  # import Aoc.Tools.Permutations

  def part1(args) do
    g =
      args
      |> parse_input()
      |> build_graph()

    find_all_paths(g)
    |> Enum.map(&length_path(&1, g))
    |> Enum.min()
  end

  def part2(args) do
    g =
      args
      |> parse_input()
      |> build_graph()

    find_all_paths(g)
    |> Enum.map(&length_path(&1, g))
    |> Enum.max()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    [nodes, distance] = String.split(line, " = ", trim: true)
    [from, to] = String.split(nodes, " to ", trim: true)
    {from, to, String.to_integer(distance)}
  end

  def build_graph(input) do
    input
    |> Enum.reduce(Graph.new(type: :undirected), fn {from, to, distance}, graph ->
      graph
      |> Graph.add_edge(from, to, weight: distance)
    end)
  end

  def find_all_paths(graph) do
    graph
    |> Graph.vertices()
    |> Aoc.Tools.Permutations.permutations()
    |> Enum.filter(&valid_path?(&1, graph))
  end

  defp valid_path?(path, graph) do
    path
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [from, to] -> Graph.edge(graph, from, to) != nil end)
  end

  def length_path(path, graph) do
    path
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] -> Graph.edge(graph, from, to).weight end)
    |> Enum.sum()
  end
end
