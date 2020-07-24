defmodule Content.TermRelationship do
  @moduledoc """
  Maintains the relationship between a term_taxonomy and a post / page / or object.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Content.{Post}

  @primary_key {:object_id, :integer, []}
  @primary_key {:term_taxonomy_id, :integer, []}
  schema "wp_term_relationships" do
    field :term_order, :integer
    belongs_to :post, Post, foreign_key: :object_id, references: :id
    belongs_to :term_taxonomy,
      Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      references: :term_taxonomy_id,
      define_field: false
    belongs_to :category,
      Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      references: :term_taxonomy_id,
      define_field: false,
      where: [taxonomy: "category"]
    belongs_to :tag,
      Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      references: :term_taxonomy_id,
      define_field: false,
      where: [taxonomy: "post_tag"]
    belongs_to :post_format,
      Content.TermTaxonomy,
      foreign_key: :term_taxonomy_id,
      references: :term_taxonomy_id,
      define_field: false,
      where: [taxonomy: "post_format"]
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:object_id, :term_taxonomy_id, :term_order])
  end
end
