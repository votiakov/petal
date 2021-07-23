defmodule Legendary.Content.TermRelationship do
  @moduledoc """
  Maintains the relationship between a term_taxonomy and a post / page / or object.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Legendary.Content.Post

  @primary_key {:object_id, :integer, []}
  @primary_key {:term_taxonomy_id, :integer, []}
  schema "term_relationships" do
    field :term_order, :integer
    belongs_to :post, Post, foreign_key: :object_id, references: :id
    belongs_to :term_taxonomy,
      Legendary.Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      define_field: false
    belongs_to :category,
      Legendary.Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      define_field: false,
      where: [taxonomy: "category"]
    belongs_to :tag,
      Legendary.Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      define_field: false,
      where: [taxonomy: "post_tag"]
    belongs_to :format,
      Legendary.Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      define_field: false,
      where: [taxonomy: "post_format"]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:object_id, :term_taxonomy_id, :term_order])
  end
end
