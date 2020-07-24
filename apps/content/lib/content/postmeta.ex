defmodule Content.Postmeta do
  @moduledoc """
  An item of metadata about a post.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:meta_id, :id, autogenerate: true}
  schema "wp_postmeta" do
    belongs_to :post, Content.Post
    field :meta_key, :string
    field :meta_value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:meta_id, :post_id, :meta_key, :meta_value])
  end
end
