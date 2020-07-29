defmodule Content.Option do
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

  def put_new_value(struct, value) do
    struct
    |> change(%{value: PhpSerializer.serialize(value)})
  end
end
