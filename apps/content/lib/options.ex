defmodule Content.Options do
  @moduledoc """
  Query the option key-value pairs for the site.
  """
  alias Content.Option
  alias Content.Repo

  def get(key), do: Option |> Repo.get_by(option_name: key)

  def get_value(key) do
    case get(key) do
      nil ->
        nil
      opt ->
        opt
        |> (&(&1.option_value)).()
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
