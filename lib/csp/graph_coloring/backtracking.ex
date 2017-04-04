defmodule CSP.GraphColoring.Backtracking do
  alias CSP.GraphColoring.Graph

  def solve(graph, print) do
    do_solve(graph, print)
  end

  defp do_solve(%Graph{} = graph, print) do
    if print do
      Graph.print(graph)
      IO.puts "-------------------"
    end
    with {:ok, :valid} <- Graph.valid?(graph),
         {:ok, vertex} <- find_first_empty(graph),
         true <- increment_vertex(graph, vertex, print)
    do
      {:ok, graph}
    else
      {:error, :all_fulfilled} ->
        Graph.print(graph)
        {:ok, graph}
      _ ->
        {:error, graph}
    end
  end

  defp increment_vertex(%Graph{vertices: vertices, colors: colors} = graph, index, print) do
    Enum.any? 1..colors, fn color ->
      graph = %Graph{graph | vertices: put_elem(vertices, index, color)}
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
