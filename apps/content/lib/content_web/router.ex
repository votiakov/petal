defmodule Content.Router do
  use Content, :router
  alias AuthWeb.Plugs.{RequireAdmin}

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

  pipeline :require_admin do
    plug(RequireAdmin)
  end

  pipeline :require_auth do
    plug Pow.Plug.RequireAuthenticated, error_handler: Pow.Phoenix.PlugErrorHandler
  end

  use Content.Routes
end
