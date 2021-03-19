defmodule Legendary.Content.LayoutViewTest do
  use Legendary.Content.ConnCase, async: true

  import Legendary.Content.LayoutView

  describe "title/3" do
    def default_title do
      Legendary.I18n.t! "en", "site.title"
    end

    test "for index" do
      assert title(Legendary.Content.PostsView, "index.html", %{page: 1}) =~ "Page 1 | #{default_title()}"
    end

    test "for feed" do
      assert title(Legendary.Content.FeedsView, "index.rss", %{category: "Category Test"}) =~ "Category Test | #{default_title()}"
    end

    test "for category" do
      assert title(Legendary.Content.PostsView, "show.html", %{post: %{title: "Test"}}) =~ "Test | #{default_title()}"
    end
  end

  describe "excerpt/3" do
    test "for a post" do
      assert excerpt(Legendary.Content.PostsView, "show.html", %{post: %{excerpt: "Excerpt test"}}) =~ "Excerpt test"
    end

    test "for a category" do
      assert excerpt(Legendary.Content.FeedsView, "index.rss", %{category: "category-test"}) =~ "category-test |"
    end
  end

  describe "corresponding_feed_url/4" do
    setup %{conn: conn} do
      %{conn: put_private(conn, :phoenix_router_url, "/pages")}
    end

    test "with a nil category", %{conn: conn} do
      assert corresponding_feed_url(conn, nil, nil, %{category: nil}) == "/pages/feed.rss"
    end

    test "with a non-nil category", %{conn: conn} do
      assert corresponding_feed_url(conn, Legendary.Content.PostsView, "index.html", %{category: "test-category"}) == "/pages/category/test-category/feed.rss"
    end

    test "without a category", %{conn: conn} do
      assert corresponding_feed_url(conn, nil, nil, %{}) == "/pages/feed.rss"
    end
  end
end
