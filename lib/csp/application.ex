defmodule CSP.Application do
  @moduledoc false

  alias CSP.Counter
  alias CSP.GossipGirl
  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    switches = [switches: [size: :integer, print: :boolean, interval: :integer]]
    {opts, _, _} = OptionParser.parse(args, switches)

    Counter.start_link(:calls)
    Counter.start_link(:solutions)

    interval = case opts[:interval] do
                 nil -> 5000
                 val -> val * 1000
               end

    GossipGirl.start_link([:calls, :solutions], interval)

    Backtracking.solve(Graph.new(opts[:size]), opts[:print])

    IO.puts "Visited #{Counter.get(:calls)} nodes"
    IO.puts "Found #{Counter.get(:solutions)} solutions"
  end
end
