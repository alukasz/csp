defmodule CSP.GraphColoring.Backtracking do
  alias CSP.Counter
  alias CSP.GraphColoring.Graph

  def solve(graph, heuristic) do
    Counter.increment(:calls)

    with true <- Graph.valid?(graph),
         {:ok, vertex} <- heuristic.(graph),
         true <- place(graph, vertex, 1, heuristic)
    do
      true
    else
      {:error, :filled} -> Counter.increment(:solutions); false
      _ -> false
    end
  end

  def place(%Graph{colors: colors}, _vertex, color, heuristic) when color > colors, do: false
  def place(%Graph{vertices: vertices, colors: colors} = graph, vertex, color, heuristic) do
    graph = %Graph{graph | vertices: put_elem(vertices, vertex, color)}

    # new_graph = Enum.reduce(Graph.find_neighbours(graph, vertex), graph, fn vertex, graph ->
    #   graph = Graph.remove_allowed_color(graph, vertex, color)
    #   if elem(graph.vertices, vertex) do
    #     Enum.reduce(Graph.find_neighbours(graph, vertex), graph, fn vertex, graph ->
    #       Graph.remove_allowed_color(graph, vertex, color)
    #     end)
    #   end
    #   graph = Enum.reduce(Graph.find_pairs_with(graph, color), graph, fn color, graph ->
    #     Graph.remove_allowed_color(graph, vertex, color)
    #   end)
    #   graph
    # end)

    solve(graph, heuristic)
    place(graph, vertex, color + 1, heuristic)
  end
end
