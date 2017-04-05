defmodule CSP.Application do
  @moduledoc false

  alias CSP.Counter
  alias CSP.GossipGirl
  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.ForwardChecking
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    switches = [switches: [alg: :string, size: :integer, print: :boolean, interval: :integer]]
    {opts, _, _} = OptionParser.parse(args, switches)

    start_monitoring(opts)

    case opts[:alg] do
      "bt" -> Backtracking.solve(Graph.new(opts[:size]), opts[:print])
      "fc" -> ForwardChecking.solve(Graph.new(opts[:size], true), opts[:print])
    end

    IO.puts "Visited #{Counter.get(:calls)} nodes"
    IO.puts "Found #{Counter.get(:solutions)} solutions"
  end

  defp start_monitoring(opts) do
    Counter.start_link(:calls)
    Counter.start_link(:solutions)

    interval = case opts[:interval] do
                 nil -> 5000
                 val -> val * 1000
               end

    GossipGirl.start_link([:calls, :solutions], interval)
  end
end
