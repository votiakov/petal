defmodule Content.LayoutView do
  use Content, :view

  def feed_tag(conn, view_module, view_template, assigns) do
    ~E"""
    <link
      rel="alternate"
      type="application/rss+xml"
      title="<%= title(view_module, view_template, assigns) %>"
      href="<%= corresponding_feed_url(conn, view_module, view_template, assigns) %>"
    />
    """
  end

  def title(Content.PostsView, "index.html", assigns) do
    "Page #{assigns.page} | #{title(nil, nil, nil)}"
  end

  def title(Content.FeedsView, "index.rss", %{category: category}) when not(is_nil(category)) do
    "#{category} | #{title(nil, nil, nil)}"
  end

  def title(Content.PostsView, "show.html", assigns) do
    (assigns.post.title |> HtmlSanitizeEx.strip_tags()) <> " | " <> title(nil, nil, nil)
  end

  def title(_, _, _), do: I18n.t! "en", "site.title"

  def excerpt(Content.PostsView, "show.html", assigns) do
    assigns.post.excerpt
    |> HtmlSanitizeEx.strip_tags()
  end

  def excerpt(Content.FeedsView, "index.rss", %{category: category}) when not(is_nil(category))  do
    "#{category} | #{excerpt(nil, nil, nil)}"
  end

  def excerpt(_, _, _), do: I18n.t! "en", "site.excerpt"

  def corresponding_feed_url(conn, _, _, %{category: nil}) do
    Content.Router.Helpers.index_feed_url(conn, :index)
  end

  def corresponding_feed_url(conn, Content.PostsView, "index.html", %{category: category}) do
    Content.Router.Helpers.category_feed_url(conn, :index, category)
  end

  def corresponding_feed_url(conn, _, _, _) do
    Content.Router.Helpers.index_feed_url(conn, :index)
  end
end
