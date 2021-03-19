defmodule Legendary.Content.SitemapController do
  use Legendary.Content, :controller

  alias Legendary.Content.{Posts, Repo, Terms}

  import Ecto.Query

  def index(conn, _params) do
    posts =
      Posts.post_scope
      |> where([p], p.type not in ["nav_menu_item", "attachment"])
      |> Repo.all()

    categories =
      Terms.categories
        |> Repo.all()

    render(conn, "index.html", conn: conn, posts: posts, categories: categories)
  end
end
