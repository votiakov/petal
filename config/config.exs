use Mix.Config

[
  {:admin, Admin, false},
  {:app, AppWeb, true},
  {:core, AuthWeb, false},
  {:content, Content, false},
  {:core, CoreWeb, false},
]
|> Enum.map(fn {otp_app, module, start_server} ->
  endpoint = Module.concat(module, "Endpoint")
  error_view = Module.concat(module, "ErrorView")

  config otp_app, endpoint,
    url: [host: "localhost"],
    secret_key_base: "r2eN53mJ9RmlGz9ZQ7xf43P3Or59aaO9rdf5D3hRcsuiH44pGW9kPGfl5mt9N1Gi",
    render_errors: [view: error_view, accepts: ~w(html json), layout: false],
    pubsub_server: App.PubSub,
    live_view: [signing_salt: "g5ltUbnQ"],
    server: start_server
end)

[
  {:admin, Admin.Repo},
  {:app, App.Repo},
  {:content, Content.Repo},
  {:core, Core.Repo},
]
|> Enum.map(fn
  {otp_app, repo} ->
    config otp_app,
      ecto_repos: [repo],
      generators: [context_app: otp_app]

  {otp_app, repo, context_app} ->
    config otp_app,
      ecto_repos: [repo],
      generators: [context_app: context_app]
end)

config :core, :pow,
  user: Auth.User,
  repo: Core.Repo,
  extensions: [PowEmailConfirmation, PowPersistentSession, PowResetPassword],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: AuthWeb.Pow.Mailer,
  web_mailer_module: AuthWeb,
  web_module: AuthWeb

config :core, email_from: "example@example.org"

# Configures Elixir's Logger
config :logger, :console,
  level: :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :linguist, pluralization_key: :count

config :content,
  Oban,
  repo: Content.Repo,
  queues: [default: 10],
  crontab: [
    {"0 * * * *", Content.Sitemaps},
  ]

import_config "email_styles.exs"
import_config "admin.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
