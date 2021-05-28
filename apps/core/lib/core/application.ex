defmodule Legendary.Core.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies)

    children = [
      {Cluster.Supervisor, [topologies, [name: Legendary.Core.ClusterSupervisor]]},
      Legendary.Auth.MnesiaClusterSupervisor,
      # Start the Ecto repository
      Legendary.Core.Repo,
      # Start the Telemetry supervisor
      Legendary.CoreWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Legendary.Core.PubSub},
      # Start the Endpoint (http/https)
      Legendary.CoreWeb.Endpoint,
      # Start a worker by calling: Legendary.Core.Worker.start_link(arg)
      # {Legendary.Core.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Legendary.Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Legendary.CoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
