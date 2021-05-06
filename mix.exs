defmodule Legendary.Mixfile do
  use Mix.Project

  @version "2.4.1"

  def project do
    [
      name: "Legendary",
      version: @version,
      apps_path: "apps",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      "deps.get": ["cmd mix deps.get"],
      "coveralls.html": ["cmd mix coveralls.html"],
      "ecto.migrate": ["cmd mix ecto.migrate"],
      "npm.install": ["cmd mix npm.install"],
      test: ["cmd mix test"]
    ]
  end
end
