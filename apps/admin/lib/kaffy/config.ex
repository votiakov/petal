defmodule Legendary.Admin.Kaffy.Config do
  def create_resources(_conn) do
    config = Application.get_env(:admin, Legendary.Admin)

    {resources, _} = Keyword.pop(config, :resources, [])

    resources
  end
end
