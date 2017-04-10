defmodule CSP.Application do
  @moduledoc false

  import ExProf.Macro

  alias CSP.Counter
  alias CSP.GossipGirl
  alias CSP.NQueens.Backtracking, as: NQueensBT
  alias CSP.NQueens.ForwardChecking, as: NQueensFC
  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.ForwardChecking
  alias CSP.GraphColoring.Heuristic
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    switches = [switches: [alg: :string, size: :integer, print: :boolean, interval: :integer, h: :string]]
    {opts, _, _} = OptionParser.parse(args, switches)

    start_monitoring(opts)

    heuristic = case opts[:h] do
                  "mc" ->
                    IO.puts "Heuristic: most constraints"
                    &Heuristic.most_constraints(&1)
                  "lc" ->
                    IO.puts "Heuristic: least constraints"
                    &Heuristic.least_constraints(&1)
                  _ ->
                    IO.puts "Heuristic: first empty"
                    &Heuristic.first_empty(&1)
    end

    # records = profile do
      function = case opts[:alg] do
        "gcbt" ->
          IO.puts "Algorithm: graph coloring backtracking"
          measure(fn -> Backtracking.solve(Graph.new(opts[:size]), heuristic) end)
        "gcfc" ->
          IO.puts "Algorithm: graph coloring forwardchecking"
          measure(fn -> ForwardChecking.solve(Graph.new(opts[:size]), heuristic) end)
        "nqbt" ->
          IO.puts "Algorithm: n queens backtracking"
          NQueensBT.solve(opts[:size])
        "nqfc" ->
          IO.puts "Algorithm: n queens forwardchecking"
          NQueensFC.solve(opts[:size])
      end
    # end

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
    |> IO.puts
  end
end
