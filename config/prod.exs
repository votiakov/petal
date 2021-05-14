use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.

secret_key_base = System.get_env("SECRET_KEY_BASE")
signing_salt = System.get_env("LIVE_VIEW_SIGNING_SALT")

[
  {:admin, Legendary.Admin, false},
  {:app, AppWeb, true},
  {:content, ContentWeb, false},
  {:core, Legendary.CoreWeb, false},
]
|> Enum.map(fn {otp_app, module, start_server} ->
  endpoint = Module.concat(module, "Endpoint")
  extra_opts =
    if start_server do
      [cache_static_manifest: "priv/static/cache_manifest.json"]
    else
      []
    end

  config otp_app, endpoint, [
    url: [host: "example.com", port: 80],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    pubsub_server: App.PubSub,
    live_view: [signing_salt: signing_salt],
    server: start_server
  ] ++ extra_opts
end)

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :admin, Legendary.Admin.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

database_url = System.get_env("DATABASE_URL")

[
  {:admin, Legendary.Admin.Repo},
  {:app, App.Repo},
  {:content, Legendary.Content.Repo},
  {:core, Legendary.Core.Repo}
]
|> Enum.map(fn {otp_app, repo} ->
  config otp_app, repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end)

config :core, Legendary.CoreMailer,
  adapter: Bamboo.SMTPAdapter,
  server: {:system, "SMTP_HOST"},
  hostname: {:system, "HOSTNAME"},
  port: 25,
  username: {:system, "SMTP_USERNAME"},
  password: {:system, "SMTP_PASSWORD"},
  tls: :if_available,
  allowed_tls_versions: [:"tlsv1", :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 1,
  no_mx_lookups: false,
  auth: :always

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :auth_web, Legendary.AuthWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :content, Legendary.Content.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :content, Legendary.Content.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
