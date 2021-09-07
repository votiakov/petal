defmodule Legendary.Content.SitemapsTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Post, Repo}

  import Mock

  import Legendary.Content.Sitemaps

  @xml ~s(
    <?xml version="1.0" encoding="UTF-8"?>
<urlset
  xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
  xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
    http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
  xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'
  xmlns:geo='http://www.google.com/geo/schemas/sitemap/1.0'
  xmlns:news='http://www.google.com/schemas/sitemap-news/0.9'
  xmlns:image='http://www.google.com/schemas/sitemap-image/1.1'
  xmlns:video='http://www.google.com/schemas/sitemap-video/1.1'
  xmlns:mobile='http://www.google.com/schemas/sitemap-mobile/1.0'
  xmlns:pagemap='http://www.google.com/schemas/sitemap-pagemap/1.0'
  xmlns:xhtml='http://www.w3.org/1999/xhtml'
>
<url>
  <loc>https://localhost</loc>
  <lastmod>2021-08-19T21:44:37Z</lastmod>
  <changefreq>hourly</changefreq>
  <priority>0.5</priority>
</url><url>
  <loc>https://localhost/public-post</loc>
  <lastmod>2021-08-19T21:44:37Z</lastmod>
  <changefreq>hourly</changefreq>
  <priority>0.5</priority>
</url><url>
  <loc>https://localhost/public-post?page=2</loc>
  <lastmod>2021-08-19T21:44:37Z</lastmod>
  <changefreq>hourly</changefreq>
  <priority>0.5</priority>
</url></urlset>
)

  describe "generate/0" do
    setup do
      public_post =
        %Post{
          title: "Public post",
          name: "public-post",
          status: "publish",
          type: "post",
          date: ~N[2020-01-01T00:00:00],
          content: """
          Page 1
          <!--nextpage-->
          Page 2
          """
        }
        |> Repo.insert!()

      %{
        public_post: public_post,
      }
    end

    test "generates results" do
      with_mock Sitemap.Funcs, [
        iso8601: fn -> "2021-08-19T21:44:37Z" end,
        iso8601: & &1,
        eraser: fn (elm) -> passthrough([elm]) end
      ] do
        with_mock Legendary.Content.SitemapStorage, [write: fn (_name, _data) -> :ok end] do
          assert :ok = perform(%{})
          assert_called Legendary.Content.SitemapStorage.write(:file, String.trim(@xml))
        end
      end
    end
  end
end
