defmodule Legendary.Core.MapUtils do
  @moduledoc """
  Generic additional utility functions for Maps.
  """

  def deep_merge(base, override) do
    Map.merge(base, override, &deep_value/3)
  end

  defp deep_value(_key, %{} = base, %{} = override) do
    deep_merge(base, override)
  end

  defp deep_value(_key, _base, override) do
    override
  end
end
