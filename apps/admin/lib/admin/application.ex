defmodule Legendary.Admin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Legendary.Admin.Repo,
      # Start the Telemetry supervisor
      Legendary.Admin.Telemetry,
      # Start the Endpoint (http/https)
      Legendary.Admin.Endpoint
      # Start a worker by calling: Legendary.Admin.Worker.start_link(arg)
      # {Legendary.Admin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Legendary.Admin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Legendary.Admin.Endpoint.config_change(changed, removed)
    :ok
  end
end
