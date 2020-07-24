defmodule Content.PostsController do
  use Content, :controller

  alias Auth.User
  alias Content.{Options, Post, Posts, Repo}

  plug :put_layout, false when action in [:preview]

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

  def new(conn, params) do
    changeset = Posts.change_posts(%Post{})
    render(
      conn,
      "new.html",
      changeset: changeset,
      post_type: params["post_type"] || "post",
      author_options: User |> Repo.all()
    )
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_posts(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Posts created successfully.")
        |> redirect(to: Routes.posts_path(conn, :show, post))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "new.html",
          changeset: changeset,
          post_type: post_params["post_type"] || "post",
          author_options: User |> Repo.all()
        )
    end
  end

  def preview(conn, %{"post" => post_params}) do
    post = Posts.preview_post(post_params)

    conn
    |> render("show.html", post: post, page: 1, thumbs: [])
  end

  def show(conn, %{"id" => id, "page" => page_string}) do
    {page_id_for_posts, _} = Options.get_value_as_int("page_for_posts")

    post = Posts.get_post(id)

    if is_nil(post) do
      try_static_post(conn, id)
    else
      if post.id == page_id_for_posts do
        conn |> index_posts(%{"id" => id, "page" => page_string})
      else
        conn |> show_one(post, page_string)
      end
    end
  end
  def show(conn, %{"id" => id}), do: show(conn, %{"id" => id, "page" => "1"})

  defp try_static_post(conn, id) do
    path = "static_pages/#{id}.html"
    try do
      render(conn, path)
    rescue
      e in Phoenix.Template.UndefinedError ->
        case e do
          %{template: ^path} ->
            # The static page we're looking for is missing, so this is just a 404
            raise Phoenix.Router.NoRouteError.exception(conn: conn, router: Content.Router)
          _ ->
            # We aren't missing the static page, we're missing a partial. This is probably
            # a developer error, so bubble it up
            raise e
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
    case post.post_type do
      "attachment" ->
        {:ok, decoded} = post.post_content |> Base.decode64

        conn
        |> put_resp_content_type(post.post_mime_type, "binary")
        |> send_resp(conn.status || 200, decoded)
      _ ->
        render(conn, template, post: post, page: page, thumbs: thumbs)
    end
  end

  def edit(conn, %{"id" => id}) do
    posts = Posts.get_post_with_drafts!(id)
    changeset = Posts.change_posts(posts)
    render(
      conn,
      "edit.html",
      posts: posts,
      changeset: changeset,
      post_type: posts.post_type || "post",
      author_options: User |> Repo.all()
    )
  end

  def update(conn, %{"id" => id, "post" => posts_params}) do
    posts = Posts.get_post_with_drafts!(id)

    case Posts.update_posts(posts, posts_params) do
      {:ok, posts} ->
        conn
        |> put_flash(:info, "Posts updated successfully.")
        |> redirect(to: Routes.posts_path(conn, :edit, posts))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(
          conn,
          "edit.html",
          posts: posts,
          changeset: changeset,
          post_type: posts.post_type || "post",
          author_options: User |> Repo.all()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    posts = Posts.get_post_with_drafts!(id)
    {:ok, _posts} = Posts.delete_posts(posts)

    conn
    |> put_flash(:info, "Posts deleted successfully.")
    |> redirect(to: Routes.admin_posts_path(conn, :index))
  end
end
