defmodule Content.AdminPostsController do
  use Content, :controller

  alias Content.Posts

  require Ecto.Query

  def index(conn, %{"page" => page, "post_type" => post_type}) do
    posts = Posts.list_admin_posts(page, post_type)
    thumbs = posts |> Posts.thumbs_for_posts()
    last_page = Posts.last_page
    render(
      conn,
      "index.html",
      [
        posts: posts,
        page: String.to_integer(page),
        last_page: last_page,
        thumbs: thumbs,
        post_type: post_type,
      ]
    )
  end
  def index(conn, %{"page" => page} = params), do: index(conn, params |> Map.merge(%{"page" => page, "post_type" => "post"}))
  def index(conn, %{"post_type" => post_type} = params), do: index(conn, params |> Map.merge(%{"page" => "1", "post_type" => post_type}))
  def index(conn, params), do: index(conn, params |> Map.merge(%{"page" => "1", "post_type" => "post"}))
end
