use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :content, Content.Repo,
  username: "postgres",
  password: "postgres",
  database: "content_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: System.get_env("DATABASE_URL") || "localhost",
  show_sensitive_data_on_connection_error: true,
  pool: Ecto.Adapters.SQL.Sandbox
