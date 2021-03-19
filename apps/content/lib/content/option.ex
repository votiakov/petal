defmodule Legendary.Content.Option do
  @moduledoc """
  A configuration option for the site.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    field :name, :string
    field :autoload, :string
    field :value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id, :name, :value, :autoload])
  end

  def parse_value(struct) do
    case PhpSerializer.unserialize(struct.value) do
      {:ok, values} ->
        values
    end
  end
end
