defmodule AppWeb.Router do
  use AppWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  alias AuthWeb.Plugs.{RequireAdmin}

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_layout, {AppWeb.LayoutView, :app}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :require_admin do
    plug(RequireAdmin)
  end

  pipeline :require_auth do
    plug Pow.Plug.RequireAuthenticated, error_handler: Pow.Phoenix.PlugErrorHandler
  end

  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end

    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  use Admin.Routes
  use Content.Routes
end
