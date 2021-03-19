defmodule Legendary.Content.SitemapControllerTest do
  use Legendary.Content.ConnCase

  describe "index" do
    test "is the site index", %{conn: conn} do
      conn = get conn, Routes.sitemap_path(conn, :index)
      assert html_response(conn, 200) =~ "Site Index"
    end
  end
end
