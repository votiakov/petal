use Mix.Config

# Configures the endpoint
config :app, App.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TOB3UL0s6bHCiBoCnflb5GZTHlA6gvvq2BlRurVQca0WcK8Lf+b2xq/KahpWSvJs",
  render_errors: [view: App.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "H9ynuZL0"]

config :admin,
  ecto_repos: [Admin.Repo],
  generators: [context_app: false]

config :app,
  ecto_repos: [App.Repo],
  generators: [context_app: :app]

# Configures the endpoint
config :admin, Admin.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r2eN53mJ9RmlGz9ZQ7xf43P3Or59aaO9rdf5D3hRcsuiH44pGW9kPGfl5mt9N1Gi",
  render_errors: [view: Admin.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Admin.PubSub,
  live_view: [signing_salt: "g5ltUbnQ"]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r2eN53mJ9RmlGz9ZQ7xf43P3Or59aaO9rdf5D3hRcsuiH44pGW9kPGfl5mt9N1Gi",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "g5ltUbnQ"]

# Configure Mix tasks and generators
config :auth,
  ecto_repos: [Auth.Repo]

config :auth_web,
  ecto_repos: [Auth.Repo],
  generators: [context_app: :auth]

config :auth_web, :pow,
  user: Auth.User,
  repo: Auth.Repo,
  extensions: [PowEmailConfirmation, PowPersistentSession, PowResetPassword],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: AuthWeb.Pow.Mailer,
  web_mailer_module: AuthWeb,
  web_module: AuthWeb

# Configures the endpoint
config :auth_web, AuthWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cjtU4RvTirW4yJZDkdqZJmaj7bvaQRrX6mevkoGYqzEuMujV/Q0w3utlO5+FUsUj",
  render_errors: [view: AuthWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AuthWeb.PubSub,
  live_view: [signing_salt: "AwljJYaY"]

config :content, Content.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kNJbLKCmuZYSK99S55+DmirA2TlmOxzs/xz3xnlXtOhQCoBMmYRabaRLTXkcsw5d",
  render_errors: [view: Content.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Content.PubSub,
  live_view: [signing_salt: "Nb8V5NUr"]

config :admin,
  ecto_repos: [Admin.Repo]

config :core, email_from: "example@example.org"

config :content,
  generators: [context_app: false]

config :content, Content.Endpoint, server: false
config :auth_web, AuthWeb.Endpoint, server: false
config :admin, Admin.Endpoint, server: false
config :app, CoreWeb.Endpoint, server: false

import_config "../apps/*/config/config.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :linguist, pluralization_key: :count

import_config "email_styles.exs"
import_config "admin.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
