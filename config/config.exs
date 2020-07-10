use Mix.Config

config :core,
  router_forwards: [Content.Router],
  email_from: "example@example.org"

config :content,
  generators: [context_app: false]

config :content, Content.Endpoint, server: false

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
