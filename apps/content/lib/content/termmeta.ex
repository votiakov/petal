defmodule Legendary.Content.Termmeta do
  @moduledoc """
  Represents one piece of metadata around one "term" (a grouping under a taxonomy).
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "termmeta" do
    field :term_id, :integer
    field :key, :string
    field :value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :term_id, :key, :value])
  end
end
