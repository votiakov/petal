defmodule Content.Application do
  @moduledoc """
  The base module of the Content application.
  """
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Content.Repo, []),
      # Start the endpoint when the application starts
      # Start your own worker by calling: Content.Worker.start_link(arg1, arg2, arg3)
      # worker(Content.Worker, [arg1, arg2, arg3]),
      Content.Telemetry,
      Content.Endpoint,
      {Oban, oban_config()},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Content.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Content.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable crontab, queues, or plugins here.
  defp oban_config do
    Application.get_env(:content, Oban)
  end
end
