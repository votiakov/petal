defmodule Content.Termmeta do
  @moduledoc """
  Represents one piece of metadata around one "term" (a grouping under a taxonomy).
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:meta_id, :id, autogenerate: true}
  schema "wp_termmeta" do
    field :term_id, :integer
    field :meta_key, :string
    field :meta_value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:meta_id, :term_id, :meta_key, :meta_value])
  end
end
