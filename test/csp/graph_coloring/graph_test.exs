defmodule CSP.GraphColoring.GraphTest do
  use ExUnit.Case, async: true

  alias CSP.GraphColoring.Graph

  describe "Graph.new/1" do
    setup do
      graph = Graph.new(2)

      {:ok, graph: graph}
    end

    test "has correct size", %{graph: graph} do
      assert graph.size == 2
    end

    test "has vertices set to null", %{graph: graph} do
      vertices = graph.vertices |> Tuple.to_list

      assert Enum.all?(vertices, &is_nil(&1))
      assert length(vertices) == 4
    end

    test "has correct edges", %{graph: graph} do
      assert {0, 1} in graph.edges
      assert {2, 3} in graph.edges
      assert {0, 2} in graph.edges
      assert {1, 3} in graph.edges
      assert length(graph.edges) == 4
    end

    test "has correct number of colors for even size" do
      graph = Graph.new(4)

      assert graph.colors == 8
    end

    test "has correct number of colors for odd size" do
      graph = Graph.new(5)

      assert graph.colors == 11
    end
  end

  describe "Graph.valid?/1" do
    test "is valid for empty graph" do
      graph = Graph.new(3)

      assert Graph.valid?(graph)
    end

    test "is valid for unique colors" do
      graph = Graph.new(3)
      graph = %Graph{graph | vertices: {1, 2, 3, 4, 5, 6, 7, 8, 9}}

      assert Graph.valid?(graph)
    end

    test "is invalid for 2 matching pairs of colors" do
      graph = Graph.new(3)
      graph = %Graph{graph | vertices: {1, 2, 3, 4, 1, 2, 7, 8, 9}}

      refute Graph.valid?(graph)
    end

    test "is invalid for 2 matching pairs of colors in reverse order" do
      graph = Graph.new(3)
      graph = %Graph{graph | vertices: {1, 2, 3, 4, 5, 2, 1, 8, 9}}

      refute Graph.valid?(graph)
    end
  end
end
