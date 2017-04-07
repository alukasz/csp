defmodule CSP.Application do
  @moduledoc false

  import ExProf.Macro

  alias CSP.Counter
  alias CSP.GossipGirl
  alias CSP.NQueens
  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.ForwardChecking
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    switches = [switches: [alg: :string, size: :integer, print: :boolean, interval: :integer]]
    {opts, _, _} = OptionParser.parse(args, switches)

    start_monitoring(opts)

    # records = profile do
      case opts[:alg] do
      "gcbt" -> Backtracking.solve(Graph.new(opts[:size]))
      "gcfc" -> ForwardChecking.solve(Graph.new(opts[:size], true))
      "nqbt" -> NQueens.solve(opts[:size])
      end
    # end

    IO.puts "Visited #{Counter.get(:calls)} nodes"
    IO.puts "Found #{Counter.get(:solutions)} solutions"
  end

  defp start_monitoring(opts) do
    Counter.start_link(:calls)
    Counter.start_link(:solutions)

    interval = case opts[:interval] do
                 nil -> 50
                 val -> val * 10
               end

    GossipGirl.start_link([:calls, :solutions], interval)
  end
end
