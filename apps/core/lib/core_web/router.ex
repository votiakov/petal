defmodule CoreWeb.Router do
  use CoreWeb, :router

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

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: CoreWeb.Telemetry
    end
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/", Content do
    pipe_through :browser

    get "/", PostsController, :index
  end

  Application.get_env(:core, :router_forwards, [])
  |> Enum.map(fn {router, path} ->
    forward path, router
  end)
end
