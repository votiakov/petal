defmodule Admin.Router do
  use Admin, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :require_admin do
    plug AuthWeb.Plugs.RequireAdmin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  use Kaffy.Routes, scope: "/", pipe_through: [:require_admin]
end
