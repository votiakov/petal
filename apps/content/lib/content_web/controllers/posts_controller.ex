defmodule Legendary.Content.PostsController do
  use Legendary.Content, :controller

  alias Legendary.Content.{Options, Posts}

  plug :put_layout, false when action in [:preview]

  def index(conn, %{"category" => _} = params) do
    conn |> index_posts(params)
  end

  def index(conn, params) do
    show_on_front = Options.get_value("show_on_front") || "page"

    case show_on_front do
      "posts" ->
        conn |> index_posts(params)
      "page" ->
        conn |> index_page(params)
    end
  end

  def index_posts(conn, params) do
    page = params |> Map.get("page", "1")
    params = params |> Map.merge(%{"page" => page})
    category = params |> Map.get("category")
    posts =  Posts.list_posts(params)
    thumbs = posts |> Posts.thumbs_for_posts()
    last_page = Posts.last_page(params)

    conn
    |> render(
      "index.html",
      [
        posts: posts,
        page: String.to_integer(page),
        last_page: last_page,
        thumbs: thumbs,
        category: category,
      ]
    )
  end

  def index_page(conn, _params) do
    page_id = Options.get_value("page_on_front") || "index"

    show(conn, %{"id" => page_id})
  end

  def preview(conn, %{"post" => post_params}) do
    post = Posts.preview_post(post_params)

    conn
    |> render("show.html", post: post, page: 1, thumbs: [])
  end

  def show(conn, %{"id" => "blog", "page" => page_string}) do
    conn |> index_posts(%{"id" => "blog", "page" => page_string})
  end

  def show(conn, %{"id" => id, "page" => page_string}) when is_binary(id) or is_integer(id) do
    post = Posts.get_post(id)

    if is_nil(post) do
      try_static_post(conn, id)
    else
      conn |> show_one(post, page_string)
    end
  end
  def show(conn, %{"id" => id} = params) when is_list(id), do: show(conn, Map.merge(params, %{"id" => Enum.join(id, "/")}))
  def show(conn, %{"id" => id}), do: show(conn, %{"id" => id, "page" => "1"})

  defp try_static_post(conn, id) do
    path = "static_pages/#{id}.html"
    try do
      render(conn, path)
    rescue
      e in Phoenix.Template.UndefinedError ->
        case e do
          %{template: ^path} ->
            router =
              case conn do
                %{private: %{phoenix_router: router}} -> router
                _ -> Legendary.Content.Router
              end

            # The static page we're looking for is missing, so this is just a 404
            # credo:disable-for-next-line
            raise Phoenix.Router.NoRouteError.exception(conn: conn, router: router)
          _ ->
            # We aren't missing the static page, we're missing a partial. This is probably
            # a developer error, so bubble it up
            reraise e, System.stacktrace
        end
    end
  end

  def show_one(conn, post, page_string) do
    {front_page_id, _} = Options.get_value_as_int("page_on_front")

    template =
      if post.id == front_page_id do
        "front.html"
      else
        "show.html"
      end

    page = String.to_integer(page_string)
    thumbs = [post] |> Posts.thumbs_for_posts()
    case post.type do
      "attachment" ->
        {:ok, decoded} = post.content |> Base.decode64

        conn
        |> put_resp_content_type(post.mime_type, charset(post.mime_type))
        |> send_resp(conn.status || 200, decoded)
      _ ->
        render(conn, template, post: post, page: page, thumbs: thumbs)
    end
  end

  defp charset(mime_type) do
    do_charset(String.split(mime_type, "/"))
  end

  defp do_charset(["application", _]), do: "binary"
  defp do_charset(["video", _]), do: "binary"
  defp do_charset(["audio", _]), do: "binary"
  defp do_charset(["image", _]), do: "binary"
  defp do_charset(_), do: "utf-8"
end
