defmodule App.LayoutViewTest do
  use App.ConnCase, async: true

  import AppWeb.LayoutView

  describe "title/3" do
    def default_title do
      Legendary.I18n.t! "en", "site.title"
    end

    test "for nil" do
      assert title(nil, nil, nil) =~ default_title()
    end
  end

  describe "excerpt/3" do
    def default_excerpt do
      Legendary.I18n.t! "en", "site.excerpt"
    end

    test "for nil" do
      assert excerpt(nil, nil, nil) =~ default_excerpt()
    end
  end

  describe "feed_tag/4" do
    test "for nil" do
      assert feed_tag(nil, nil, nil, nil) == nil
    end
  end
end
