defmodule Legendary.Content.TermTaxonomy do
  @moduledoc """
  A record in a taxonomy which organizes terms and posts in the system.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "term_taxonomy" do
    field :taxonomy, :string
    field :description, :string
    field :parent, :integer
    field :count, :integer
    belongs_to :term, Legendary.Content.Term
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :term_id, :taxonomy, :description, :parent, :count])
  end
end
