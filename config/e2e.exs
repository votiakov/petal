use Mix.Config

# Start with test config
import_config "test.exs"

config :app, AppWeb.Endpoint,
    http: [port: 4002],
    server: true,
    watchers: [
        node: [
          "node_modules/webpack/bin/webpack.js",
          "--mode",
          "development",
          "--watch",
          "--watch-options-stdin",
          "--progress",
          cd: Path.expand("../apps/app/assets", __DIR__)
        ]
      ]
