defmodule Legendary.Content.Commentmeta do
  @moduledoc """
  A piece of metadata about a comment on the site.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "commentmeta" do
    field :comment_id, :integer
    field :key, :string
    field :value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :comment_id, :key, :value])
  end
end
