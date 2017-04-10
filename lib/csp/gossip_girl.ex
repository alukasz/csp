defmodule CSP.GossipGirl do
  @moduledoc """
  Keeps looking into others processes and telling everyone about their state.
  """

  use GenServer

  alias CSP.Counter

  def start_link(processes, interval) do
    GenServer.start_link(__MODULE__, [processes, interval], name: :gossip_girl)
  end

  def init([processes, interval]) do
    Process.send_after(self(), :tell_everyone, interval)

    {:ok, %{processes: processes, interval: interval, counter: 1}}
  end

  def handle_info(:tell_everyone, %{processes: processes, interval: interval, counter: counter}) do
    # IO.puts "Elapsed approx. #{counter * interval / 1000} seconds"
    # Enum.each processes, fn counter ->
    #   IO.puts "State of #{to_string(counter)} is #{Counter.get(counter)}"
    # end
    # IO.puts ""

    # time
    # IO.puts to_string(counter * interval / 1000) <> "," <> to_string(Counter.get(:solutions))
    # nodes
    IO.puts to_string(counter * interval / 1000) <> "," <> to_string(Counter.get(:calls)) <> "," <> to_string(Counter.get(:solutions))


    Process.send_after(self(), :tell_everyone, interval)
    {:noreply, %{processes: processes, interval: interval, counter: counter + 1}}
  end
end
