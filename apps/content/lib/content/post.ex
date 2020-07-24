defmodule Content.Post do
  @moduledoc """
  One "post" i.e. a blog post, page, attachment, or item of a custom post type.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.Slugs

  @primary_key {:id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :post_name}
  schema "wp_posts" do
    field :post_date, :naive_datetime
    field :post_date_gmt, :naive_datetime
    field :post_content, :string, default: ""
    field :post_title, :string
    field :post_excerpt, :string
    field :post_status, :string
    field :comment_status, :string
    field :ping_status, :string
    field :post_password, :string, default: ""
    field :post_name, :string
    field :to_ping, :string, default: ""
    field :pinged, :string, default: ""
    field :post_modified, :naive_datetime
    field :post_modified_gmt, :naive_datetime
    field :post_content_filtered, :string, default: ""
    field :post_parent, :integer
    field :guid, :string
    field :menu_order, :integer
    field :post_type, :string
    field :post_mime_type, :string
    field :comment_count, :integer
    field :sticky, :boolean, [virtual: true, default: false]
    has_many :metas, Content.Postmeta, foreign_key: :post_id
    has_many :comments, Content.Comment, foreign_key: :comment_post_id
    has_many :term_relationships, Content.TermRelationship, foreign_key: :object_id
    has_many :categories, through: [:term_relationships, :category, :term]
    has_many :tags, through: [:term_relationships, :tag, :term]
    has_one :post_format, through: [:term_relationships, :post_format, :term]
    belongs_to :author, Auth.User, foreign_key: :post_author
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(
      params,
      [
        :id,
        :post_author,
        :post_date,
        :post_date_gmt,
        :post_content,
        :post_title,
        :post_excerpt,
        :post_status,
        :comment_status,
        :ping_status,
        :post_password,
        :post_name,
        :to_ping,
        :pinged,
        :post_content_filtered,
        :post_parent,
        :menu_order,
        :post_type,
        :post_mime_type,
        :comment_count,
        :sticky,
    ])
    |> put_default(:post_date, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_default(:post_date_gmt, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_change(:post_modified, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_change(:post_modified_gmt, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> Slugs.ensure_post_has_slug()
    |> maybe_put_guid()
    |> validate_required([:post_name, :post_status])
    |> validate_inclusion(:post_status, ["publish", "future", "draft", "pending", "private", "trash", "auto-draft", "inherit"])
  end

  def put_default(changeset, key, value) do
    if is_nil(changeset |> get_field(key)) do
      changeset
      |> put_change(key, value)
    else
      changeset
    end
  end

  def before_more(string) do
    string
    |> String.split("<!--more-->")
    |> Enum.at(0)
  end

  def content_page(struct, page) do
    (struct.post_content || "")
    |> String.split("<!--nextpage-->")
    |> Enum.at(page - 1)
    |> Kernel.||("")
  end

  def content_page_count(struct) do
    (struct.post_content || "")
    |> String.split("<!--nextpage-->")
    |> Enum.count
  end

  def paginated_post?(struct) do
    content_page_count(struct) > 1
  end

  def metas_map(list) when is_list(list) do
    list
    |> Enum.map(fn post ->
      {post.id, metas_map(post)}
    end)
    |> Map.new
  end
  def metas_map(%Content.Post{} = struct) do
    struct.metas
    |> Enum.map(&({&1.meta_key, &1.meta_value}))
    |> Map.new
  end

  def maybe_put_guid(changeset) do
    import Content.Router.Helpers, only: [posts_url: 3]
    slug = changeset |> get_field(:post_name)

    case slug do
      nil -> changeset
      _ ->
        changeset
        |> put_default(:guid, posts_url(CoreWeb.Endpoint, :show, slug))
    end
  end
end
