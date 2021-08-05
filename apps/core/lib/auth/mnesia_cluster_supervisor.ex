defmodule Legendary.Auth.MnesiaClusterSupervisor do
  @moduledoc """
  Manages the cache in Mnesia for Pow. This allows users to remain logged in
  even if their traffic is hitting different nodes in the cluster.
  """

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Pow.Store.Backend.MnesiaCache, extra_db_nodes: Node.list()},
      Pow.Store.Backend.MnesiaCache.Unsplit
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
