defmodule Content.Router do
  use Content, :router
  alias Content.{RequireAdmin, RequireAuth}

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

  pipeline :feed do
    plug :accepts, ["rss"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :require_auth do
    plug(RequireAuth)
  end

  pipeline :require_admin do
    plug(RequireAdmin)
  end

  pipeline :admin_layout do
    plug :put_layout, {Content.LayoutView, :admin}
  end

  scope "/", Content do
    pipe_through([:browser, :require_auth, :require_admin, :admin_layout])

    get "/wp-admin/", AdminHomeController, :index
    get "/posts", AdminPostsController, :index, as: :admin_posts
    post "/posts", PostsController, :create
    get "/posts/new", PostsController, :new
    put "/posts/preview", PostsController, :preview
    post "/posts/preview", PostsController, :preview
    get "/posts/:id/edit", PostsController, :edit
    put "/posts/:id", PostsController, :update
    delete "/posts/:id", PostsController, :delete
    get "/menus/:id/edit", MenusController, :edit
    put "/menus/:id", MenusController, :update
  end

  scope "/", Content do
    pipe_through :feed # Use the default browser stack

    get "/category/:category/feed.rss", FeedsController, :index, as: :category_feed
    get "/feed.rss", FeedsController, :index, as: :index_feed
  end

  scope "/", Content do
    pipe_through :browser # Use the default browser stack

    resources "/comments", CommentController, as: :comment, only: [:create, :delete, :update]
    get "/page/:page", PostsController, :index_posts, as: :blog_page
    get "/category/:category", PostsController, :index_posts, as: :category
    get "/category/:category/page/:page", PostsController, :index, as: :category_page
    post "/wp-login.php", PostPasswordController, :create
    get "/", PostsController, :index
    resources "/sitemap", SitemapController, only: [:index]
    get "/:id", PostsController, :show
    get "/:id/:page", PostsController, :show, as: :paged_post
  end
end
