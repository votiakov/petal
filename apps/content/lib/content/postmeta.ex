defmodule Content.Postmeta do
  @moduledoc """
  An item of metadata about a post.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "postmeta" do
    belongs_to :post, Content.Post
    field :key, :string
    field :value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :post_id, :key, :value])
  end
end
