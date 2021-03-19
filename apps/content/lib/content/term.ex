defmodule Legendary.Content.Term do
  @moduledoc """
  Represents one 'term', i.e. a grouping under a taxonomy.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "terms" do
    field :name, :string
    field :slug, :string
    field :term_group, :integer
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :slug, :term_group])
  end
end
