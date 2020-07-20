defmodule Content.Mixfile do
  use Mix.Project

  def project do
    [
      app: :content,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Content.Application, []},
      extra_applications: [:logger, :runtime_tools, :sitemap]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:content_web, in_umbrella: true},
      {:phoenix, "~> 1.5.3"},
      {:phoenix_pubsub, "~> 2.0"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, "~> 0.15.0"},
      {:plug_cowboy, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 2.7"},
      {:php_serializer, "~> 0.9.0"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.1"},
      {:excoveralls, "~> 0.10", only: [:dev, :test]},
      {:phoenix_html_sanitizer, "~> 1.0.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:earmark, "~> 1.4.2" },
      {:slugger, "~> 0.3"},
      {:ecto, "~> 3.4.3"},
      {:floki, "~> 0.25.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:meck, "~> 0.8.13", only: :test},
      {:sitemap, "~> 1.1"},
      {:neotomex, "~> 0.1.7"},
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
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
