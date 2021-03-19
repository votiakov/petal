defmodule Legendary.Content.Options do
  @moduledoc """
  Query the option key-value pairs for the site.
  """
  alias Legendary.Content.Option
  alias Legendary.Content.Repo

  def put(key, value) do
    %Option{}
    |> Option.changeset(%{
      name: key,
      value: value,
    })
    |> Repo.insert()
  end

  def get(key), do: Option |> Repo.get_by(name: key)

  def get_value(key) do
    case get(key) do
      nil ->
        nil
      opt ->
        opt
        |> (&(&1.value)).()
    end
  end

  def get_value_as_int(key) do
    case get_value(key) do
      nil ->
        {nil, nil}
      opt ->
        opt
        |> Integer.parse()
    end
  end
end
