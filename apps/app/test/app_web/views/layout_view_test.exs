defmodule App.LayoutViewTest do
  use AppWeb.ConnCase, async: true

  import AppWeb.LayoutView
  import Phoenix.HTML, only: [safe_to_string: 1]

  alias Legendary.Content.Post

  @post %Post{
    title: "Test Post",
    excerpt: "This is a test post.",
    modified_gmt: ~N[2021-09-17T00:00:00],
    date_gmt: ~N[2021-09-15T00:00:00]
  }

  describe "title/3" do
    def default_title do
      Legendary.I18n.t! "en", "site.title"
    end

    test "for nil" do
      assert title(nil, nil, nil) =~ default_title()
    end

    test "for post" do
      assert title(nil, nil, %{post: @post}) =~ "Test Post | #{default_title()}"
    end
  end

  describe "excerpt/3" do
    def default_excerpt do
      Legendary.I18n.t! "en", "site.excerpt"
    end

    test "for nil" do
      assert excerpt(nil, nil, nil) =~ default_excerpt()
    end

    test "for post" do
      assert excerpt(nil, nil, %{post: @post}) =~ "This is a test post."
    end
  end

  describe "feed_tag/4" do
    test "for nil" do
      assert feed_tag(nil, nil, nil, nil) == nil
    end
  end

  describe "modified_tag/3" do
    test "for a post" do
      assert safe_to_string(modified_tag(nil, nil, %{post: @post})) =~ "2021-09-17"
    end

    test "without a post" do
      assert modified_tag(nil, nil, nil) == nil
    end
  end

  describe "published_tag/3" do
    test "for a post" do
      assert safe_to_string(published_tag(nil, nil, %{post: @post})) =~ "2021-09-15"
    end

    test "without a post" do
      assert published_tag(nil, nil, nil) == nil
    end
  end
end
