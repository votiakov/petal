defmodule Legendary.Content.Link do
  @moduledoc """
  A link for the (deprecated) link roll feature.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :url, :string
    field :name, :string
    field :image, :string
    field :target, :string
    field :description, :string
    field :visible, :string
    field :owner, :integer
    field :rating, :integer
    field :updated, :naive_datetime
    field :rel, :string
    field :notes, :string
    field :rss, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :id,
      :url,
      :name,
      :image,
      :target,
      :description,
      :visible,
      :owner,
      :rating,
      :updated,
      :rel,
      :notes,
      :rss
    ])
  end
end
