defmodule Legendary.Content.Post do
  @moduledoc """
  One "post" i.e. a blog post, page, attachment, or item of a custom post type.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Legendary.Content.{MarkupField, Slugs}

  @derive {Phoenix.Param, key: :name}
  schema "posts" do
    field :date, :naive_datetime
    field :date_gmt, :naive_datetime
    field :content, MarkupField, default: ""
    field :title, :string
    field :excerpt, :string
    field :status, :string
    field :comment_status, :string
    field :ping_status, :string
    field :password, :string, default: ""
    field :name, :string
    field :to_ping, :string, default: ""
    field :pinged, :string, default: ""
    field :modified, :naive_datetime
    field :modified_gmt, :naive_datetime
    field :content_filtered, :string, default: ""
    field :parent, :integer
    field :guid, :string
    field :menu_order, :integer
    field :type, :string
    field :mime_type, :string
    field :comment_count, :integer
    field :sticky, :boolean, [virtual: true, default: false]
    has_many :metas, Legendary.Content.Postmeta
    has_many :comments, Legendary.Content.Comment
    has_many :term_relationships, Legendary.Content.TermRelationship, foreign_key: :object_id
    has_many :categories, through: [:term_relationships, :category, :term]
    has_many :tags, through: [:term_relationships, :tag, :term]
    has_one :format, through: [:term_relationships, :format, :term]
    belongs_to :author, Legendary.Auth.User
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(
      params,
      [
        :id,
        :author_id,
        :date,
        :date_gmt,
        :content,
        :title,
        :excerpt,
        :status,
        :comment_status,
        :ping_status,
        :password,
        :name,
        :to_ping,
        :pinged,
        :content_filtered,
        :parent,
        :menu_order,
        :type,
        :mime_type,
        :comment_count,
        :sticky,
    ])
    |> put_default(:date, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_default(:date_gmt, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_change(:modified, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> put_change(:modified_gmt, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> Slugs.ensure_post_has_slug()
    |> maybe_put_guid()
    |> validate_required([:name, :status])
    |> validate_inclusion(:status, ["publish", "future", "draft", "pending", "private", "trash", "auto-draft", "inherit"])
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
    (struct.content || "")
    |> String.split("<!--nextpage-->")
    |> Enum.at(page - 1)
    |> Kernel.||("")
  end

  def content_page_count(struct) do
    (struct.content || "")
    |> String.split("<!--nextpage-->")
    |> Enum.count
  end

  def paginated_post?(struct) do
    content_page_count(struct) > 1
  end

  def metas_map(%Legendary.Content.Post{} = struct) do
    struct.metas
    |> Enum.map(&({&1.key, &1.value}))
    |> Map.new
  end

  def maybe_put_guid(changeset) do
    import Legendary.Content.Router.Helpers, only: [url: 1, posts_url: 3]
    guid = changeset |> get_field(:guid)

    case guid do
      nil ->
        base = url(Legendary.CoreWeb.Endpoint)
        slug = changeset |> get_field(:name)

        changeset
        |> put_default(:guid, posts_url(URI.merge(base, "/pages"), :show, slug))
      _ ->
        changeset
    end
  end
end
