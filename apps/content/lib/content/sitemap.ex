defmodule Content.Sitemaps do
  @moduledoc """
    This module generates sitemaps for the website and pings search engines as
    appropriate.
  """
  alias Content.{Endpoint, Post, Posts, Repo,  Router.Helpers, Terms}
  import Ecto.Query

  require Logger

  use Oban.Worker

  use Sitemap,
    host: "https://#{Application.get_env(:content, Endpoint)[:url][:host]}",
    files_path: "tmp/sitemap/",
    public_path: "",
    adapter: Content.SitemapStorage

  @impl Oban.Worker
  def perform(_job) do
    generate()
  end

  def generate do
    create do
      add "", priority: 0.5, changefreq: "hourly", expires: nil

      posts =
        Posts.post_scope
        |> where([p], p.type not in ["nav_menu_item", "attachment"])
        |> Repo.all()

      for post <- posts do
        add Helpers.posts_path(Endpoint, :show, post), priority: 0.5, changefreq: "hourly", expires: nil
        page_count = Post.content_page_count(post)
        if page_count > 1 do
          (2..page_count)
          |> Enum.each(fn page ->
            add Helpers.paged_post_path(Endpoint, :show, post, page), priority: 0.5, changefreq: "hourly", expires: nil
          end)
        end
      end

      Terms.categories
      |> Repo.all()
      |> Enum.each(fn category ->
        add Helpers.category_path(Endpoint, :index_posts, category.slug), priority: 0.5, changefreq: "hourly", expires: nil
      end)
    end

    # notify search engines (currently Google and Bing) of the updated sitemap
    if Mix.env() == :prod, do: ping()

    Logger.info "Sitemap generated."

    :ok
  end
end
