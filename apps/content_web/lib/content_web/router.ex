defmodule ContentWeb.Router do
  use ContentWeb, :router

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

  scope "/", ContentWeb do
    pipe_through :browser

    get "/posts/:id", PostsController, :show
    get "/:id", PageController, :show
  end
end
