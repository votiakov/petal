defmodule Legendary.Content.SitemapStorageTest do
  use Legendary.Content.DataCase

  import Legendary.Content.SitemapStorage
  alias Sitemap.Location
  alias Legendary.Content.{Post, Repo}

  test "creates a post with the content" do
    data = "<hello />"
    content = data |> :zlib.gzip() |> Base.encode64
    write(:file, data)
    path = Location.filename(:file)

    post = from(p in Post, where: p.name == ^path) |> Repo.one()

    assert post.content == content
  end

  test "updates an existing sitemap" do
    path = Location.filename(:file)

    %Post{
      content: "<hello />" |> :zlib.gzip() |> Base.encode64,
      name: path
    }
    |> Repo.insert!()

    new_data = "<world />"
    new_content = new_data |> :zlib.gzip() |> Base.encode64

    write(:file, new_data)


    post = from(p in Post, where: p.name == ^path) |> Repo.one()

    assert post.content == new_content
  end
end
