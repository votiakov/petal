defmodule Legendary.Core.MixProject do
  use Mix.Project

  @version "2.1.2"

  def project do
    [
      app: :core,
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

      # Docs
      name: "Legendary",
      source_url: "https://gitlab.com/mythic-insight/legendary",
      homepage_url: "https://legendaryframework.org/",
      docs: [
        main: "overview",
        extra_section: "GUIDES",
        extras: extras()
      ],

      # Hex
      description: """
      A PETAL-stack batteries-included boilerplate for making Phoenix apps
      without tedium.
      """,
      package: [
        name: "legendary_core",
        maintainers: ["Robert Prehn"],
        organization: "mythic_insight",
        licenses: ["MIT"],
        links: %{"GitLab" => "https://gitlab.com/mythic-insight/legendary"}
      ]
    ]
  end

  defp extras do
    Path.wildcard("guides/**/*.md")
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Legendary.Core.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:bamboo, "~> 1.5"},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_cldr, "~> 2.13.0"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:phoenix, "~> 1.5.3"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:ex_prompt, "~> 0.1.5"},
      {:linguist, "0.3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.2.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:pow, "~> 1.0.20"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "npm.install": [],
    ]
  end
end
