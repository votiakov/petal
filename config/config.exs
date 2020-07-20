use Mix.Config

# Configure Mix tasks and generators
config :auth,
  ecto_repos: [Auth.Repo]

config :auth_web,
  ecto_repos: [Auth.Repo],
  generators: [context_app: :auth]

config :auth_web, :pow,
  user: Auth.Users.User,
  repo: Auth.Repo,
  extensions: [PowEmailConfirmation],
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

config :core,
  router_forwards: [{ContentWeb.Router, "/pages"}, {AuthWeb.Router, "/auth"}],
  email_from: "example@example.org"

config :content_web,
  generators: [context_app: false]

config :content_web, ContentWeb.Endpoint, server: false
config :auth_web, AuthWeb.Endpoint, server: false

import_config "../apps/*/config/config.exs"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :linguist, pluralization_key: :count

import_config "email_styles.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
