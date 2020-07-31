defmodule Legendary.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      test_coverage: [tool: ExCoveralls],
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      "deps.get": ["cmd mix deps.get"],
      "coveralls.html": ["cmd MIX_ENV=test mix coveralls.html"],
      "ecto.migrate": ["cmd mix ecto.migrate"],
      "npm.install": ["cmd npm install --prefix assets"],
      test: ["cmd mix test"]
    ]
  end
end
