use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, App.Endpoint,
  http: [port: 4002],
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :admin, Admin.Endpoint,
  http: [port: 4002],
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :auth, Auth.Repo,
  username: "postgres",
  password: "postgres",
  database: "legendary_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_URL") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :content, Content.Repo,
  username: "postgres",
  password: "postgres",
  database: "legendary_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_URL") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :admin, Admin.Repo,
  username: "postgres",
  password: "postgres",
  database: "legendary_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_URL") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  database: "legendary_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_URL") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :auth_web, AuthWeb.Endpoint,
  http: [port: 4002],
  server: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :content, Content.Endpoint,
  http: [port: 4002],
  server: false


config :core, CoreMailer, adapter: Bamboo.TestAdapter
