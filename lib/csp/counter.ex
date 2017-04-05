defmodule CSP.Counter do
  @moduledoc """
  Simple GenServer module for counting across application.
  """

  use GenServer

  def start_link(name, initial_value \\ 0) do
    GenServer.start_link(__MODULE__, {:ok, initial_value}, name: name)
  end

  def increment(pid) do
    GenServer.cast(pid, :increment)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def init({:ok, value}) do
    {:ok, value}
  end

  def handle_cast(:increment, state) do
    {:noreply, state + 1}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end
end
