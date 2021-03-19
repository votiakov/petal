defmodule Legendary.Content.Attachment do
  @moduledoc """
  Helpers for dealing with "attachment"-type posts, which are generally media
  uploaded to the site e.g. images.
  """
  alias Legendary.Content.Post

  def dimensions(attachment) do
    meta =
      attachment
      |> Post.metas_map

    deserialization_results =
      meta["attachment_metadata"]
      |> PhpSerializer.unserialize

    case deserialization_results do
      {:ok, info} ->
        %{
          width:  info |> Enum.find(fn {key, _} -> key == "width" end) |> elem(1),
          height: info |> Enum.find(fn {key, _} -> key == "height" end) |> elem(1)
        }
      {:error, _} ->
        nil
    end
  end

  def vertical?(attachment) do
    case dimensions(attachment) do
      %{width: width, height: height} ->
        if width < height do
          true
        else
          false
        end
      _ ->
        false
    end
  end
end
