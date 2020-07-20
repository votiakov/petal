defmodule Content.TermTaxonomy do
  @moduledoc """
  A record in a taxonomy which organizes terms and posts in the system.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:term_taxonomy_id, :id, autogenerate: true}
  schema "wp_term_taxonomy" do
    field :taxonomy, :string
    field :description, :string
    field :parent, :integer
    field :count, :integer
    belongs_to :term, Content.Term, foreign_key: :term_id, references: :term_id
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:term_taxonomy_id, :term_id, :taxonomy, :description, :parent, :count])
  end
end
