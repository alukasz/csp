defmodule CSP.Application do
  @moduledoc false

  import ExProf.Macro

  alias CSP.Counter
  alias CSP.GossipGirl
  alias CSP.NQueens.Backtracking, as: NQueensBT
  alias CSP.NQueens.ForwardChecking, as: NQueensFC
  alias CSP.NQueens.Heuristic, as: NQueensHeuristic
  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.ForwardChecking
  alias CSP.GraphColoring.Heuristic
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    switches = [switches: [prob: :string, alg: :string, size: :integer, print: :boolean, interval: :integer, h: :string]]
    {opts, _, _} = OptionParser.parse(args, switches)

    start_monitoring(opts)

    solve = case {opts[:prob], opts[:alg]} do
      {"gc", "bt"} ->
        IO.puts "Algorithm: graph coloring backtracking"
        fn heuristic -> Backtracking.solve(Graph.new(opts[:size]), heuristic) end
      {"gc", "fc"} ->
        IO.puts "Algorithm: graph coloring forwardchecking"
        fn heuristic -> ForwardChecking.solve(Graph.new(opts[:size]), heuristic) end
      {"nq", "bt"} ->
        IO.puts "Algorithm: n queens backtracking"
        fn heuristic -> NQueensBT.solve(opts[:size], heuristic) end
      {"nq", "fc"} ->
        IO.puts "Algorithm: n queens forwardchecking"
        fn heuristic -> NQueensFC.solve(opts[:size], heuristic) end
    end

    heuristic = case {opts[:prob], opts[:h]} do
      {"gc", "mc"} ->
        IO.puts "Heuristic: most constraints"
        &Heuristic.most_constraints(&1)
      {"gc", "lc"} ->
        IO.puts "Heuristic: least constraints"
        &Heuristic.least_constraints(&1)
      {"gc", "fe"} ->
        IO.puts "Heuristic: first empty"
        &Heuristic.first_empty(&1)
      {"nq", "mc"} ->
        IO.puts "Heuristic: most constraints"
        &NQueensHeuristic.most_constraints(&1, &2, &3, &4, &5)
      # {"nq", "lc"} ->
      #   IO.puts "Heuristic: least constraints"
      #   &Heuristic.least_constraints(&1)
      {"nq", "fe"} ->
        IO.puts "Heuristic: first empty"
        &NQueensHeuristic.first_empty(&1, &2, &3, &4, &5)
    end

    measure(fn -> solve.(heuristic) end)

    IO.puts "Visited #{Counter.get(:calls)} nodes"
    IO.puts "Found #{Counter.get(:solutions)} solutions"
  end

  defp start_monitoring(opts) do
    Counter.start_link(:calls)
    Counter.start_link(:solutions)

    interval = case opts[:interval] do
                 nil -> 5
                 val -> val * 1
               end

    GossipGirl.start_link([:calls, :solutions], interval)
  end

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000_000)
    |> IO.inspect
  end
end
