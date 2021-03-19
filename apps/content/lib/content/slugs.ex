defmodule Legendary.Content.Slugs do
  @moduledoc """
  Provides functions for working with post slugs and ensuring that they are unique.
  """
  import Ecto.{Changeset, Query}
  alias Legendary.Content.{Post, Repo}

  def ensure_post_has_slug(changeset) do
    cond do
      !is_nil(changeset |> get_field(:name)) ->
        changeset
      is_nil(changeset |> get_field(:title)) ->
        changeset
        |> put_change(
          :name,
          changeset
          |> get_field(:date)
          |> Kernel.||(NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
          |> Timex.format!("%F", :strftime)
          |> Slugger.slugify_downcase()
          |> unique_slug(changeset |> get_field(:id))
        )
      true ->
        changeset
        |> put_change(
          :name,
          changeset
          |> get_field(:title)
          |> Slugger.slugify_downcase()
          |> unique_slug(changeset |> get_field(:id))
        )
    end
  end

  defp unique_slug(proposed_slug, id, postfix_number \\ 0) do
    proposed_slug_with_postfix =
      if postfix_number == 0 do
        proposed_slug
      else
        "#{proposed_slug}-#{postfix_number}"
      end

    competition_count =
      Repo.aggregate(
        (
          Post
          |> where([post], post.name == ^proposed_slug_with_postfix)
          |> post_id_match(id)
        ),
        :count,
        :id
      )

    if competition_count == 0 do
      proposed_slug_with_postfix
    else
      unique_slug(proposed_slug, id, postfix_number + 1)
    end
  end

  defp post_id_match(query, nil) do
    query
  end

  defp post_id_match(query, id) when is_number(id) do
    from p in query, where: p.id != ^id
  end
end
