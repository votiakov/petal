use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
[
  {:admin, Legendary.Admin},
  {:app, AppWeb},
  {:core, Legendary.AuthWeb},
  {:content, Legendary.Content},
  {:core, Legendary.CoreWeb},
]
|> Enum.map(fn {otp_app, module} ->
  config otp_app, Module.concat(module, "Endpoint"),
    http: [port: 4002],
    server: false
end)

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.

[
  {:admin, Legendary.Admin.Repo},
  {:app, App.Repo},
  {:content, Legendary.Content.Repo},
  {:core, Legendary.Core.Repo}
]
|> Enum.map(fn {otp_app, repo} ->
  config otp_app, repo,
    username: "postgres",
    password: "postgres",
    database: "legendary_test#{System.get_env("MIX_TEST_PARTITION")}",
    hostname: System.get_env("DATABASE_URL") || "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
end)

config :core, Legendary.CoreMailer, adapter: Bamboo.TestAdapter

config :content, Oban, crontab: false, queues: false, plugins: false

config :logger, level: :warn

config :libcluster, topologies: []
