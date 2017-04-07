defmodule CSP.GraphColoring.ForwardChecking do
  alias CSP.Counter
  alias CSP.GraphColoring.Graph

  def solve(graph) do
    Counter.increment(:calls)
    with true <- Graph.valid?(graph),
         {:ok, vertex} <- find_first_empty(graph),
          true <- place(graph, vertex, Map.get(graph.allowed_colors, vertex) |> MapSet.to_list)
    do
      true
    else
      {:error, :filled} -> Counter.increment(:solutions); false
    _ -> false
    end
  end

  def place(_graph, _vertex, []), do: false
  def place(%Graph{vertices: vertices} = graph, vertex, [color | tail]) do
    graph = %Graph{graph | vertices: put_elem(vertices, vertex, color)}

    new_graph = Enum.reduce(Graph.find_neighbours(graph, vertex), graph, fn vertex, graph ->
      Graph.remove_allowed_color(graph, vertex, color)

      Enum.reduce(Graph.find_pairs_with(graph, color), graph, fn color, graph ->
        Graph.remove_allowed_color(graph, vertex, color)
      end)
    end)

    solve(new_graph)
    place(graph, vertex, tail)
  end

  defp find_first_empty(%Graph{vertices: vertices}) do
    vertices
    |> Tuple.to_list
    |> Enum.find_index(&is_nil(&1))
    |> case do
         nil -> {:error, :filled}
         vertex -> {:ok, vertex}
       end
  end
end
