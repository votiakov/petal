defmodule Legendary.Admin.Kaffy.Config do
  @moduledoc """
  Pull in the resource list for the admin from the application config.
  """

  def create_resources(_conn) do
    config = Application.get_env(:admin, Legendary.Admin)

    {resources, _} = Keyword.pop(config, :resources, [])

    resources
  end
end
