defmodule Legendary.Content.Comment do
  @moduledoc """
  A comment on the site.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Legendary.Content.{Post}

  schema "comments" do
    belongs_to :post, Post
    field :author, :string
    field :author_email, :string
    field :author_url, :string
    field :author_IP, :string
    field :date, :naive_datetime
    field :date_gmt, :naive_datetime
    field :content, :string
    field :karma, :integer
    field :approved, :string
    field :agent, :string
    field :type, :string
    field :parent, :integer, default: 0
    field :user_id, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Map.merge(%{
      date: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      date_gmt: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      approved: "1"
    })
    |> cast(params, [
      :id,
      :post_id,
      :author,
      :author_email,
      :author_url,
      :author_IP,
      :date,
      :date_gmt,
      :content,
      :karma,
      :approved,
      :agent,
      :type,
      :parent,
      :user_id
    ])
    |> validate_required([:content])
  end
end
