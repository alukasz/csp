defmodule CSP.GraphColoring.Graph do
  alias CSP.GraphColoring.Graph

  defstruct vertices: nil, edges: [], size: 0, colors: 0

  def new(size) do
    %Graph{size: size}
    |> build_vertices
    |> build_edges
    |> set_possible_colors
  end

  def print(%Graph{vertices: vertices, size: size}) do
    vertices
    |> Tuple.to_list
    |> Enum.chunk(size, size)
    |> Enum.each(fn chunk ->
      Enum.each(chunk, fn vertex -> IO.write(String.pad_leading(to_string(vertex), 4)) end)
      IO.puts ""
      end)
  end

  def valid?(%Graph{vertices: vertices, edges: edges}) do
    case do_valid(vertices, edges, MapSet.new, 0) do
      true  -> {:ok, :valid}
      false -> {:error, :invalid}
    end
  end

  defp do_valid(_, [], pairs, constraints) do
    MapSet.size(pairs) == constraints
  end
  defp do_valid(vertices, [{v1, v2} | edges], pairs, constraints) do
    case {elem(vertices, v1), elem(vertices, v2)} do
      {nil, _} -> do_valid(vertices, edges, pairs, constraints)
      {_, nil} -> do_valid(vertices, edges, pairs, constraints)
      {c, c} -> false
      {c1, c2} when c1 > c2 -> do_valid(vertices, edges, MapSet.put(pairs, {c2, c1}), constraints + 1)
      {c1, c2} -> do_valid(vertices, edges, MapSet.put(pairs, {c1, c2}), constraints + 1)
    end
  end

  defp build_vertices(%Graph{size: size} = graph) do
    vertices = for _ <- 1..(size * size), do: nil

    %Graph{graph | vertices: List.to_tuple(vertices)}
  end

  defp build_edges(%Graph{size: size} = graph) do
    hor = for row <- 0..(size - 1), col <- 0..(size - 2) do
      {row * size + col, row * size + col + 1}
    end
    ver = for row <- 0..(size - 2), col <- 0..(size - 1) do
      {row * size + col, size + row * size + col}
    end
    edges = hor ++ ver
    |> Enum.sort(fn {f1, f2}, {s1, s2} ->
      case f1 == s1 do
        false -> f1 < s1
        true -> f2 < s2
      end
    end)

    %Graph{graph | edges: edges}
  end

  defp set_possible_colors(%Graph{size: size} = graph) do
    colors = case rem(size, 2) do
               0 -> 2 * size
               1 -> 2 * size + 1
             end

    %Graph{graph | colors: colors}
  end
end
