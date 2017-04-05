defmodule CSP.Application do
  @moduledoc false

  alias CSP.Counter
  alias CSP.GossipGirl
  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    {opts, _, _} = OptionParser.parse(args, switches: [size: :integer, print: :boolean])

    Counter.start_link(:calls)
    Counter.start_link(:solutions)

    GossipGirl.start_link([:calls, :solutions], 5000)

    Backtracking.solve(Graph.new(opts[:size]), opts[:print])

    IO.puts "Visited #{Counter.get(:calls)} nodes"
    IO.puts "Found #{Counter.get(:solutions)} solutions"
  end
end
