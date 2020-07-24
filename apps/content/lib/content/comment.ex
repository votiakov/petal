defmodule Content.Comment do
  @moduledoc """
  A comment on the site.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.{Post}

  @primary_key {:comment_id, :id, autogenerate: true}
  @derive {Phoenix.Param, key: :comment_id}
  schema "wp_comments" do
    belongs_to :post, Post, foreign_key: :comment_post_id, references: :id
    field :comment_author, :string
    field :comment_author_email, :string
    field :comment_author_url, :string
    field :comment_author_IP, :string
    field :comment_date, :naive_datetime
    field :comment_date_gmt, :naive_datetime
    field :comment_content, :string
    field :comment_karma, :integer
    field :comment_approved, :string
    field :comment_agent, :string
    field :comment_type, :string
    field :comment_parent, :integer, default: 0
    field :user_id, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Map.merge(%{
      comment_date: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      comment_date_gmt: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      comment_approved: "1"
    })
    |> cast(params, [
      :comment_id,
      :comment_post_id,
      :comment_author,
      :comment_author_email,
      :comment_author_url,
      :comment_author_IP,
      :comment_date,
      :comment_date_gmt,
      :comment_content,
      :comment_karma,
      :comment_approved,
      :comment_agent,
      :comment_type,
      :comment_parent,
      :user_id
    ])
    |> validate_required([:comment_content])
  end
end
