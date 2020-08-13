defmodule Content.LayoutView do
  use Content, :view

  alias Content.{Option, Options}

  def title(Content.PostsView, "index.html", assigns) do
    "Page #{assigns.page} | #{title(nil, nil, nil)}"
  end

  def title(Content.FeedsView, "index.rss", %{category: category}) do
    "#{category} | #{title(nil, nil, nil)}"
  end

  def title(Content.PostsView, "show.html", assigns) do
    (assigns.post.title |> HtmlSanitizeEx.strip_tags()) <> " | " <> title(nil, nil, nil)
  end

  def title(_, _, _) do
    I18n.t! "en", "site.title"
  end

  def excerpt(Content.PostsView, "show.html", assigns) do
    assigns.post.excerpt
    |> HtmlSanitizeEx.strip_tags()
  end

  def excerpt(Content.FeedsView, "index.rss", %{category: category}) do
    "#{category} | #{excerpt(nil, nil, nil)}"
  end

  def excerpt(_, _, _) do
    I18n.t! "en", "site.excerpt"
  end

  def author(Content.PostsView, "show.html", assigns) do
    case assigns do
      %{author: %{display_name: name}} ->
        name
      _ ->
        "Anonymous"
    end
  end

  def author(_, _, _) do
    "Anonymous"
  end

  def corresponding_feed_url(conn, _, _, %{category: nil}) do
    Routes.index_feed_url(conn, :index)
  end

  def corresponding_feed_url(conn, Content.PostsView, "index.html", %{category: category}) do
    Routes.category_feed_url(conn, :index, category)
  end

  def corresponding_feed_url(conn, _, _, _) do
    Routes.index_feed_url(conn, :index)
  end
end
