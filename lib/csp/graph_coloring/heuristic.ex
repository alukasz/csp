defmodule CSP.GraphColoring.Heuristic do
  alias CSP.GraphColoring.Graph

  def first_empty(%Graph{vertices: vertices}) do
    vertices
    |> Tuple.to_list
    |> Enum.find_index(&is_nil(&1))
    |> case do
         nil -> {:error, :filled}
         vertex -> {:ok, vertex}
       end
  end

  def most_constraints(%Graph{vertices: vertices, allowed_colors: allowed_colors}) do
    # IO.inspect allowed_colors
    # IO.inspect vertices
    {vertex, _,} = Enum.reduce allowed_colors, {nil, 100}, fn {index, colors}, {vertex, min} ->
      colors = MapSet.size(colors)
      case {colors < min, elem(vertices, index)} do
        {true, nil} -> {index , colors}
        _ -> {vertex, min}
      end
    end
    # IO.inspect vertex
    # IO.puts "================================================"
    case vertex do
      nil -> {:error, :filled}
      vertex -> {:ok, vertex}
    end
  end

  def least_constraints(%Graph{vertices: vertices, allowed_colors: allowed_colors}) do
    {vertex, _,} = Enum.reduce allowed_colors, {nil, 0}, fn {index, colors}, {vertex, max} ->
      colors = MapSet.size(colors)
      case {colors > max, elem(vertices, index)} do
        {true, nil} -> {index , colors}
        _ -> {vertex, max}
      end
    end
    case vertex do
      nil -> {:error, :filled}
      vertex -> {:ok, vertex}
    end
  end


end
