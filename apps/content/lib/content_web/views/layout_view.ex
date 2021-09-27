defmodule Legendary.Content.LayoutView do
  use Legendary.Content, :view

  def feed_tag(conn, assigns), do: feed_tag(conn, view_module(conn), view_template(conn), assigns)

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

  def title(conn, assigns), do: title(view_module(conn), view_template(conn), assigns)

  def title(Legendary.Content.PostsView, "index.html", assigns) do
    "Page #{assigns.page} | #{title(nil, nil, nil)}"
  end

  def title(Legendary.Content.FeedsView, "index.rss", %{category: category}) when not(is_nil(category)) do
    "#{category} | #{title(nil, nil, nil)}"
  end

  def title(Legendary.Content.PostsView, "show.html", assigns) do
    (assigns.post.title |> HtmlSanitizeEx.strip_tags()) <> " | " <> title(nil, nil, nil)
  end

  def title(_, _, _), do: Legendary.I18n.t! "en", "site.title"

  def excerpt(conn, assigns), do: excerpt(view_module(conn), view_template(conn), assigns)

  def excerpt(Legendary.Content.PostsView, "show.html", assigns) do
    assigns.post.excerpt
    |> HtmlSanitizeEx.strip_tags()
  end

  def excerpt(Legendary.Content.FeedsView, "index.rss", %{category: category}) when not(is_nil(category))  do
    "#{category} | #{excerpt(nil, nil, nil)}"
  end

  def excerpt(_, _, _), do: Legendary.I18n.t! "en", "site.excerpt"

  def corresponding_feed_url(conn, _, _, %{category: nil}) do
    Legendary.Content.Router.Helpers.index_feed_url(conn, :index)
  end

  def corresponding_feed_url(conn, Legendary.Content.PostsView, "index.html", %{category: category}) do
    Legendary.Content.Router.Helpers.category_feed_url(conn, :index, category)
  end

  def corresponding_feed_url(conn, _, _, _) do
    Legendary.Content.Router.Helpers.index_feed_url(conn, :index)
  end
end
