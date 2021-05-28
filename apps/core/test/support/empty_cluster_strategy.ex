defmodule Legendary.Core.Cluster.EmptyClusterStrategy do
  @moduledoc """
  A libcluster nil strategy that always returns no nodes.
  """
  use GenServer
  use Cluster.Strategy

  alias Cluster.Strategy.State

  def start_link([%State{} = state]) do
    new_state = %State{state | :meta => []}
    GenServer.start_link(__MODULE__, [new_state])
  end

  @impl true
  def init([state]) do
    {:ok, state, :infinity}
  end

  @impl true
  def handle_info(_, state) do
    {:noreply, state, :infinity}
  end
end
