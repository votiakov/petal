defmodule Legendary.Content.MixProject do
  use Mix.Project

  @version "4.0.6"

  def project do
    [
      app: :content,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Legendary.Content.Application, []},
      extra_applications: [:logger, :runtime_tools, :sitemap]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:core, in_umbrella: true},
      {:earmark, "1.4.15"},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:floki, ">= 0.30.0"},
      {:gettext, "~> 0.11"},
      {:html_sanitize_ex, "~> 1.4.1"},
      {:jason, "~> 1.0"},
      {:mime, "~> 2.0.1"},
      {:mock, "~> 0.3.0", only: :test},
      {:meck, "~> 0.8.13", only: :test},
      {:neotomex, "~> 0.1.7"},
      {:oban, "~> 2.1"},
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.3"},
      {:ecto_sql, "~> 3.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_dashboard, "~> 0.5.0"},
      {:php_serializer, "~> 2.0.0"},
      {:plug_cowboy, "~> 2.0"},
      {:sitemap, "~> 1.1"},
      {:slugger, "~> 0.3"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:timex, "~> 3.1"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "npm.install": [],
    ]
  end
end
