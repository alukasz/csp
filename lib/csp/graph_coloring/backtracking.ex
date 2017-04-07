defmodule CSP.GraphColoring.Backtracking do
  alias CSP.Counter
  alias CSP.GraphColoring.Graph

  def solve(graph) do
    Counter.increment(:calls)

    with true <- Graph.valid?(graph),
         {:ok, vertex} <- find_first_empty(graph),
         true <- place(graph, vertex, 1)
    do
      true
    else
      {:error, :filled} -> Counter.increment(:solutions); false
      _ -> false
    end
  end

  def place(%Graph{colors: colors}, _vertex, color) when color > colors, do: false
  def place(%Graph{vertices: vertices, colors: colors} = graph, vertex, color) do
    new_graph = %Graph{graph | vertices: put_elem(vertices, vertex, color)}
    solve(new_graph)
    place(graph, vertex, color + 1)
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
