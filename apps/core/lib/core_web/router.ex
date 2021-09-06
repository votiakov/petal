defmodule Legendary.CoreWeb.Router do
  use Legendary.CoreWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: Legendary.CoreWeb.Telemetry
    end
  end

  if Mix.env() in [:e2e, :test] do
    forward("/end-to-end", Legendary.CoreWeb.Plug.TestEndToEnd, otp_app: :app)
  end
end
