defmodule Legendary.Mixfile do
  use Mix.Project

  @version "3.0.2"

  def project do
    [
      name: "Legendary",
      version: @version,
      apps_path: "apps",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test, "coveralls.json": :test],
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      "deps.get": ["cmd mix deps.get"],
      "ecto.migrate": ["cmd mix ecto.migrate"],
      "npm.install": ["cmd mix npm.install"]
    ]
  end
end
