defmodule Legendary.Content.Routes do
  @moduledoc """
  Routes for the content engine, including blog posts, feeds, and pages.
  """

  defmacro __using__(_opts \\ []) do
    quote do
      pipeline :feed do
        plug :accepts, ["rss"]
        plug :fetch_session
        plug :protect_from_forgery
        plug :put_secure_browser_headers
      end

      scope "/", Legendary.Content do
        pipe_through([:browser, :require_auth, :require_admin])

        put "/posts/preview", PostsController, :preview
        post "/posts/preview", PostsController, :preview
      end

      scope "/", Legendary.Content do
        pipe_through :feed # Use the default browser stack

        get "/category/:category/feed.rss", FeedsController, :index, as: :category_feed
        get "/feed.rss", FeedsController, :index, as: :index_feed
      end

      scope "/", Legendary.Content do
        pipe_through :browser # Use the default browser stack

        resources "/comments", CommentController, as: :comment, only: [:create, :delete, :update]
        get "/page/:page", PostsController, :index_posts, as: :blog_page
        get "/category/:category", PostsController, :index_posts, as: :category
        get "/category/:category/page/:page", PostsController, :index, as: :category_page
        post "/wp-login.php", PostPasswordController, :create
        get "/", PostsController, :index
        resources "/sitemap", SitemapController, only: [:index]
        get "/:id", PostsController, :show
        get "/*id", PostsController, :show, as: :nested_posts
      end
    end
  end
end
