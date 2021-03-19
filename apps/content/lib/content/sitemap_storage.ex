defmodule Legendary.Content.SitemapStorage do
  @moduledoc """
    This module serves as a storage adapter for the Sitemap package. It writes
    the sitemap as an attachment post into the system, so that the CMS will
    serve it up.
  """
  alias Legendary.Content.{Endpoint, Post, Repo, Router.Helpers}
  alias Ecto.Changeset
  alias Sitemap.{Location}
  import Ecto.Query

  @behaviour Sitemap.Adapters.Behaviour

  def write(name, data) do
    path = Location.filename(name)
    existing_post = Post |> from() |> where([name: ^path]) |> Repo.one()

    gzip? = Regex.match?(~r/.gz$/, path)

    mime = case gzip? do
      true ->
        "application/gzip"
      false ->
        "application/xml"
    end

    data_processed = data |> :zlib.gzip() |> Base.encode64

    post_params = %{
      date: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      date_gmt: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      content: data_processed,
      title: path,
      excerpt: "",
      status: "publish",
      comment_status: "closed",
      ping_status: "closed",
      password: "",
      name: path,
      to_ping: "",
      pinged: "",
      modified: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      modified_gmt: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      content_filtered: "",
      parent: 0,
      guid: Helpers.posts_url(Endpoint, :show, path),
      menu_order: 0,
      type: "attachment",
      mime_type: mime,
      comment_count: 0,
      sticky: 0,
    }

    case existing_post do
      nil ->
        %Post{}
        |> Changeset.change(post_params)
        |> (fn (post) ->
          try do
            post |> Repo.insert!()
          rescue
            Ecto.ConstraintError -> post |> Repo.update!()
          end
        end).()
      post ->
        post |> Changeset.change(post_params) |> Repo.update!()
    end
  end
end
