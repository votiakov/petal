defmodule Content.SitemapControllerTest do
  use Content.ConnCase

  describe "index" do
    test "is the site index", %{conn: conn} do
      conn = get conn, Routes.sitemap_path(conn, :index)
      assert html_response(conn, 200) =~ "Site Index"
    end
  end
end
