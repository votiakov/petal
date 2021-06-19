defmodule Legendary.Content.FeedsController do
  use Legendary.Content, :controller

  alias Legendary.Content.{Posts}

  def index(conn, params) do
    category = params |> Map.get("category")
    posts =  Posts.list_posts(params)
    thumbs = posts |> Posts.thumbs_for_posts()

    feed_url =
      case category do
        nil ->
          Routes.index_feed_path(conn, :index)
        _ ->
          Routes.category_feed_path(conn, :index, category)
      end

    conn
    |> put_resp_content_type("text/xml")
    |> render(
      "index.rss",
      [
        posts: posts,
        thumbs: thumbs,
        category: category,
        feed_url: feed_url,
      ]
    )
  end
end
