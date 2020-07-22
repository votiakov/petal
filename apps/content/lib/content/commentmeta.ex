defmodule Content.Commentmeta do
  @moduledoc """
  A piece of metadata about a comment on the site.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:meta_id, :id, autogenerate: true}
  schema "wp_commentmeta" do
    field :comment_id, :integer
    field :meta_key, :string
    field :meta_value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:meta_id, :comment_id, :meta_key, :meta_value])
  end
end
