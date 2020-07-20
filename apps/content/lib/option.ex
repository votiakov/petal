defmodule Content.Option do
  @moduledoc """
  A configuration option for the site.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:option_id, :id, autogenerate: true}
  schema "wp_options" do
    field :option_name, :string
    field :autoload, :string
    field :option_value, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:option_id, :option_name, :option_value, :autoload])
  end

  def parse_option_value(struct) do
    case PhpSerializer.unserialize(struct.option_value) do
      {:ok, values} ->
        values
    end
  end

  def put_new_value(struct, value) do
    struct
    |> change(%{option_value: PhpSerializer.serialize(value)})
  end
end
