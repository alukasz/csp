defmodule CSP.GraphColoring.ForwardChecking do
  alias CSP.Counter
  alias CSP.GraphColoring.Graph

  def solve(graph, heuristic) do
    Counter.increment(:calls)
    with true <- Graph.valid?(graph),
         {:ok, vertex} <- heuristic.(graph),
          true <- place(graph, vertex, Map.get(graph.allowed_colors, vertex) |> MapSet.to_list, heuristic)
    do
      true
    else
      {:error, :filled} -> Counter.increment(:solutions); false
    _ -> false
    end
  end

  def place(_graph, _vertex, [], heuristic), do: false
  def place(%Graph{vertices: vertices} = graph, vertex, [color | tail], heuristic) do
    # :timer.sleep(100)

    # IO.inspect vertices
    # IO.inspect graph.allowed_colors
    graph = %Graph{graph | vertices: put_elem(vertices, vertex, color)}
    graph = Graph.remove_allowed_color(graph, vertex, color)

    # IO.puts "vertex " <> to_string(vertex) <> " set color to " <> to_string(color)
    # IO.inspect graph.vertices
    # IO.write "other colors"
    # IO.inspect tail

    old_vertex = vertex

    new_graph = Enum.reduce(Graph.find_neighbours(graph, vertex), graph, fn vertex, graph ->
      graph = Graph.remove_allowed_color(graph, vertex, color)
      # IO.puts "vertex " <> to_string(vertex) <> " remove color " <> to_string(color)

      if elem(graph.vertices, vertex) do
        Enum.reduce(Graph.find_neighbours(graph, vertex), graph, fn vertex, graph ->
          # IO.puts "neighbour vertex " <> to_string(vertex) <> " remove color " <> to_string(color)

          Graph.remove_allowed_color(graph, vertex, color)
        end)
      end

      graph = Enum.reduce(Graph.find_pairs_with(graph, color), graph, fn color, graph ->
        # IO.puts "vertex " <> to_string(vertex) <> " remove color " <> to_string(color)

        Graph.remove_allowed_color(graph, vertex, color)
      end)
      graph
    end)

    # IO.inspect new_graph.allowed_colors
    # IO.puts "========================================================="
    solve(new_graph, heuristic)
    place(graph, vertex, tail, heuristic)
  end
end

# new_graph = graph.vertices
# |> IO.inspect
# |> Tuple.to_list
# |> Enum.with_index
# |> Enum.filter(fn
#   {c, i} when is_nil(c) -> true
#   _ -> false
# end)
# |> Enum.map(fn {v, i} -> i end)
# |> IO.inspect
# |> Enum.reduce(graph, fn {vertex, graph} ->
#   neighbours = Graph.find_neighbours(graph, vertex)
#   |> Enum.filter
#   neighbours_colors = Enum.reduce Graph.find_pairs_with(graph,)
# end)

