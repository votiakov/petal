defmodule Content.LayoutViewTest do
  use Content.ConnCase

  # When testing helpers, you may want to import Phoenix.HTML and
  # use functions such as safe_to_string() to convert the helper
  # result into an HTML string.
  # import Phoenix.HTML

  import Content.LayoutView

  describe "title/3" do
    def default_title do
      I18n.t! "en", "site.title"
    end

    test "for index" do
      assert title(Content.PostsView, "index.html", %{page: 1}) =~ "Page 1 | #{default_title()}"
    end

    test "for feed" do
      assert title(Content.FeedsView, "index.rss", %{category: "Category Test"}) =~ "Category Test | #{default_title()}"
    end

    test "for category" do
      assert title(Content.PostsView, "show.html", %{post: %{title: "Test"}}) =~ "Test | #{default_title()}"
    end

    test "for nil" do
      title(nil, nil, nil)
    end
  end

  describe "excerpt/3" do
    test "for a post" do
      assert excerpt(Content.PostsView, "show.html", %{post: %{excerpt: "Excerpt test"}}) =~ "Excerpt test"
    end

    test "for a category" do
      assert excerpt(Content.FeedsView, "index.rss", %{category: "category-test"}) =~ "category-test |"
    end
  end

  describe "author/3" do
    test "with a display name" do
      assert author(Content.PostsView, "show.html", %{author: %{display_name: "Rufus"}}) =~ "Rufus"
    end

    test "without a display name" do
      assert author(Content.PostsView, "show.html", %{}) =~ "Anonymous"
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
      assert corresponding_feed_url(conn, Content.PostsView, "index.html", %{category: "test-category"}) == "/pages/category/test-category/feed.rss"
    end

    test "without a category", %{conn: conn} do
      assert corresponding_feed_url(conn, nil, nil, %{}) == "/pages/feed.rss"
    end
  end
end
