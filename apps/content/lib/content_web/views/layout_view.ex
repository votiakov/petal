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
    (assigns.post.post_title |> HtmlSanitizeEx.strip_tags()) <> " | " <> title(nil, nil, nil)
  end

  def title(_, _, _) do
    case Options.get("blogname") do
      opt = %Option{} ->
        opt.option_value
      _ ->
        "Hello"
    end
  end

  def excerpt(Content.PostsView, "show.html", assigns) do
    assigns.post.post_excerpt
    |> HtmlSanitizeEx.strip_tags()
  end

  def excerpt(Content.FeedsView, "index.rss", %{category: category}) do
    "#{category} | #{excerpt(nil, nil, nil)}"
  end

  def excerpt(_, _, _) do
    case Options.get("blogdescription") do
      opt = %Option{} ->
        opt.option_value
      _ ->
        "Yet another website"
    end
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

  def menu_markup(menu_items, conn), do: menu_markup(menu_items, conn, 0)
  def menu_markup(nil, _, _), do: ""
  def menu_markup([], _, _), do: ""
  def menu_markup(menu_items, conn, level) do
    ~E"""
      <ul style="--menu-level: <%= level %>;">
        <%= for item <- menu_items do %>
          <li>
            <label>
            <%= case item[:type] do %>
              <% "category" -> %>
              <%= link item[:related_item].title, to: Routes.category_path(conn, :index_posts, item[:related_item].slug) %>
              <% _ -> %>
              <%= link item[:related_item].title, to: Routes.posts_path(conn, :show, item[:related_item].slug) %>
            <% end %>
            <%= menu_markup(item[:children], conn, level + 1) %>
            </label>
          </li>
        <% end %>
      </ul>
    """
  end
end
