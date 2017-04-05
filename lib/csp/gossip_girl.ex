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

    {:ok, %{processes: processes, interval: interval}}
  end

  def handle_info(:tell_everyone, %{processes: processes, interval: interval} = state) do
    Enum.each processes, fn counter ->
      IO.puts "State of #{to_string(counter)} is #{Counter.get(counter)}"
    end
    IO.puts ""

    Process.send_after(self(), :tell_everyone, interval)
    {:noreply, state}
  end
end
