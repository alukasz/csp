defmodule CSP.GraphColoring.ForwardChecking do
  alias CSP.Counter
  alias CSP.GraphColoring.Graph

  def solve(graph, print) do
    do_solve(graph, print)
  end

  defp do_solve(%Graph{} = graph, print) do
    Counter.increment(:calls)
    with {:ok, :valid} <- Graph.valid?(graph),
         {:ok, vertex} <- find_first_empty(graph),
         true <- increment_vertex(graph, vertex, print)
    do
      {:ok, graph}
    else
      {:error, :all_fulfilled} ->
        Counter.increment(:solutions)
      if print do
        IO.inspect graph
        Graph.print(graph)
        IO.puts "-------------------"
      end
        {:error, graph}
      _ ->
        {:error, graph}
    end
  end

  defp increment_vertex(%Graph{vertices: vertices, allowed_colors: colors} = graph, vertex, print) do
    Enum.any? Map.get(colors, vertex), fn color ->
      graph = %Graph{graph | vertices: put_elem(vertices, vertex, color)}
      graph = Enum.reduce(Graph.find_neighbours(graph, vertex), graph, fn vertex, graph ->
        Graph.remove_allowed_color(graph, vertex, color)
      end)
      {result, _} = do_solve(graph, print)
      result == :ok
    end
  end

  defp find_first_empty(%Graph{vertices: vertices}) do
    vertices = vertices |> Tuple.to_list
    case Enum.find_index(vertices, &is_nil(&1)) do
      nil -> {:error, :all_fulfilled}
      index -> {:ok, index}
    end
  end
end
