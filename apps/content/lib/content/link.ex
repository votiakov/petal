defmodule Content.Link do
  @moduledoc """
  A link for the (deprecated) link roll feature.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:link_id, :id, autogenerate: true}
  schema "wp_links" do
    field :link_url, :string
    field :link_name, :string
    field :link_image, :string
    field :link_target, :string
    field :link_description, :string
    field :link_visible, :string
    field :link_owner, :integer
    field :link_rating, :integer
    field :link_updated, :naive_datetime
    field :link_rel, :string
    field :link_notes, :string
    field :link_rss, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :link_id,
      :link_url,
      :link_name,
      :link_image,
      :link_target,
      :link_description,
      :link_visible,
      :link_owner,
      :link_rating,
      :link_updated,
      :link_rel,
      :link_notes,
      :link_rss
    ])
  end
end
