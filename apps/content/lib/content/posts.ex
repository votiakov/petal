defmodule Legendary.Content.Posts do
  @page_size 3

  @moduledoc """
  The Legendary.Content context.
  """

  import Ecto.Query, warn: false
  alias Legendary.Content.Repo

  alias Legendary.Content.Option
  alias Legendary.Content.Post
  alias Ecto.Changeset

  @preloads [:metas, :author, :categories, :tags, :comments, :format]

  @doc """
  Returns the lisdpt of posts for admin interface.

  ## Examples

      iex> list_admin_posts()
      [%Post{}, ...]

  """
  def list_admin_posts(page, type \\ "post") do
    type = type || "post"
    Repo.all(
      from p in Post,
        where: p.type == ^type,
        where: p.status in ["publish", "future", "draft", "pending", "private", "inherit"],
        preload: ^@preloads,
        order_by: [desc: p.date],
        limit: @page_size,
        offset: ^(@page_size * (String.to_integer(page) - 1))
    )
  end

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(params \\ %{}) do
    page = params |> Map.get("page", "1")

    normal_posts =
      params
      |> post_scope_for_params()
      |> limit(@page_size)
      |> offset(^(@page_size * (String.to_integer(page) - 1)))
      |> Repo.all()

    sticky_posts_for_page(params) ++ normal_posts
  end

  def post_scope_for_params(params) do
    type = params |> Map.get("type", "post")
    category = params |> Map.get("category")

    query =
      post_scope()
      |> where([p], p.type == ^type)

    if category do
      query |> join(:inner, [p], term in assoc(p, :categories), on: term.slug == ^category)
    else
      query
    end
  end

  def post_scope do
    from p in Post,
      where: p.status == "publish",
      preload: ^@preloads,
      order_by: [desc: p.date]
  end

  def post_scope_with_drafts do
    from p in Post,
      preload: ^@preloads,
      order_by: [desc: p.date]
  end

  def sticky_posts_for_page(%{"page" => "1"} = params) do
    sticky_posts =
      params
      |> post_scope_for_params()
      |> where([p], p.id in ^sticky_ids())
      |> Repo.all()

    sticky_posts
    |> Enum.map(fn post ->
      post
      |> Changeset.change(%{sticky: true})
      |> Changeset.apply_changes()
    end)
  end
  def sticky_posts_for_page(_), do: []

  defp sticky_ids do
    case Repo.one(from opt in Option, where: opt.name == "sticky_posts") do
      nil ->
        []
      option ->
        option
        |> Option.parse_value
        |> Enum.map(&(elem(&1, 1)))
    end
  end

  def last_page(params \\ %{}) do
    post_count =
      params
      |> post_scope_for_params()
      |> Repo.aggregate(:count, :id)

    post_count
    |> (&(&1 / @page_size)).()
    |> Float.ceil
    |> trunc
  end

  def thumbs_for_posts(posts) do
    post_to_thumbnail_id =
      posts
      |> Enum.map(fn post -> {post.id, (post |>  Post.metas_map)["_thumbnail_id"]} end)
      |> Enum.reject(&(elem(&1, 1) == nil))

    thumbs =
      Post
      |> preload(:metas)
      |> where([thumb], thumb.id in ^Enum.map(post_to_thumbnail_id, &(elem(&1, 1))))
      |> Repo.all()
      |> Enum.map(fn thumb -> {thumb.id, thumb} end)
      |> Map.new

    post_to_thumbnail_id
    |> Enum.map(fn {key, value} -> {key, thumbs[String.to_integer(value)]} end)
    |> Map.new
  end

  @doc """
  Gets a single posts.

  Raises `Ecto.NoResultsError` if the Wp posts does not exist.

  ## Examples

      iex> get_posts!(123)
      %Post{}

      iex> get_posts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_posts!(slug) do
    slug
    |> get_post_scope()
    |> Repo.one!()
  end

  def get_post(slug) do
    slug
    |> get_post_scope()
    |> Repo.one()
  end

  defp get_post_scope(slug) do
    id_filter = fn scope, id ->

      case Integer.parse(id, 10) do
        :error ->
          scope |> where([p], p.name == ^id)
        {int_id, _} ->
          scope |> where([p], p.id == ^int_id)
      end
    end

    post_scope()
    |> where([p], p.type != "nav_menu_item")
    |> id_filter.(slug)
  end

  @doc """
  Gets a single post that may or may not be in draft status.

  Raises `Ecto.NoResultsError` if the Wp posts does not exist.

  ## Examples

      iex> get_post_with_drafts!(123)
      %Post{}

      iex> get_post_with_drafts!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_with_drafts!(slug) do
    id_filter = fn scope, id ->

      case Integer.parse(id, 10) do
        :error ->
          scope |> where([p], p.name == ^id)
        {int_id, ""} ->
          scope |> where([p], p.id == ^int_id)
        {_int_id, _} ->
          scope |> where([p], p.name == ^id)
      end
    end

    post_scope_with_drafts()
    |> where([p], p.type != "nav_menu_item")
    |> id_filter.(slug)
    |> Repo.one!()
  end

  @doc """
  Creates a posts.

  ## Examples

      iex> create_posts(%{field: value})
      {:ok, %Post{}}

      iex> create_posts(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_posts(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Builds a post for preview, but does not save it.
  """
  def preview_post(attrs \\ %{}) do
    %Post{}
    |> Repo.preload(@preloads)
    |> Post.changeset(attrs)
    |> Changeset.put_change(:name, "preview")
    |> Changeset.apply_changes()
  end

  @doc """
  Updates a posts.

  ## Examples

      iex> update_posts(posts, %{field: new_value})
      {:ok, %Post{}}

      iex> update_posts(posts, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_posts(%Post{} = posts, attrs) do
    posts
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_posts(posts)
      {:ok, %Post{}}

      iex> delete_posts(posts)
      {:error, %Ecto.Changeset{}}

  """
  def delete_posts(%Post{} = posts) do
    Repo.delete(posts)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking posts changes.

  ## Examples

      iex> change_posts(posts)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_posts(%Post{} = posts) do
    Post.changeset(posts, %{})
  end
end
