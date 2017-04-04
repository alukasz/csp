defmodule CSP.Application do
  @moduledoc false

  alias CSP.GraphColoring.Backtracking
  alias CSP.GraphColoring.Graph

  def main(args \\ []) do
    {opts, _, _} = OptionParser.parse(args, switches: [size: :integer, print: :boolean])

    {_, graph} = Backtracking.solve(Graph.new(opts[:size]), opts[:print])
  end
end
