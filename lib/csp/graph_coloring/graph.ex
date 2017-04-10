defmodule CSP.GraphColoring.Graph do
  alias CSP.GraphColoring.Graph

  defstruct vertices: nil, edges: [], allowed_colors: %{}, size: 0, colors: 0

  def new(size, allowed_colors \\ true) do
    %Graph{size: size}
    |> build_vertices
    |> build_edges
    |> set_possible_colors
    |> build_allowed_colors(allowed_colors)
    # |> build_neighbours
  end

  # defp build_neighbours(%Graph{ size: size, edges: edges} = graph) do
  #   neighbours = Tuple.duplicate([], size * size)

  #   Enum.reduce 0..(size * size - 1), neighbours, fn vertex, neighbours ->
  #     Enum.reduce find_neighbours(vertex), [], fn  end
  #   end
  # end

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
    do_valid(vertices, edges, MapSet.new, 0)
  end

  def remove_allowed_color(%Graph{allowed_colors: allowed_colors} = graph, vertex, color) do
    allowed_colors = Map.update!(allowed_colors, vertex, fn colors ->
      MapSet.delete(colors, color)
    end)

    %Graph{graph | allowed_colors: allowed_colors}
  end

  # returns vertices
  def find_neighbours(%Graph{edges: edges}, vertex) do
    do_find_neighbours(edges, vertex)
  end

  defp do_find_neighbours([], _), do: []
  defp do_find_neighbours([edge | edges], vertex) do
    case edge do
      {other, ^vertex} -> [other | do_find_neighbours(edges, vertex)]
      {^vertex, other} -> [other | do_find_neighbours(edges, vertex)]
      _ -> do_find_neighbours(edges, vertex)
    end
  end

  # returns colors
  def find_pairs_with(%Graph{vertices: vertices, edges: edges}, color) do
    do_find_pairs_with(vertices, edges, color)
  end

  defp do_find_pairs_with(_, [], _color), do: []
  defp do_find_pairs_with(vertices, [{v1, v2} | edges], color) do
    case {elem(vertices, v1), elem(vertices, v2)}do
      {other, ^color} when not is_nil(other)
        -> [other | do_find_pairs_with(vertices, edges, color)]
      {^color, other} when not is_nil(other)
        -> [other | do_find_pairs_with(vertices, edges, color)]
      _ -> do_find_pairs_with(vertices, edges, color)
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
    %Graph{graph | vertices: Tuple.duplicate(nil, size * size)}
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

  defp build_allowed_colors(graph, false), do: graph
  defp build_allowed_colors(%Graph{colors: colors, vertices: vertices} = graph, true) do
    allowed_colors = 1..tuple_size(vertices)
    |> Enum.map(fn vertex -> {vertex - 1, Enum.into(1..colors, MapSet.new)} end)
    |> Enum.into(%{})

    %Graph{graph | allowed_colors: allowed_colors}
  end
end
