defmodule AppWeb.LayoutView do
  use AppWeb, :view

  def title(conn, assigns), do: title(view_module(conn), view_template(conn), assigns)

  def title(view, template, %{post: post}), do: "#{post.title} | #{title(view, template, nil)}"

  def title(_, _, _) do
    Legendary.I18n.t!("en", "site.title")
  end

  def excerpt(conn, assigns), do: excerpt(view_module(conn), view_template(conn), assigns)

  def excerpt(_, _, %{post: post}) do
    post.excerpt
  end

  def excerpt(_, _, _) do
    Legendary.I18n.t!("en", "site.excerpt")
  end

  def feed_tag(conn, assigns), do: feed_tag(conn, view_module(conn), view_template(conn), assigns)

  def feed_tag(_, _, _, _) do
    nil
  end

  def modified_tag(conn, assigns), do: modified_tag(view_module(conn), view_template(conn), assigns)

  def modified_tag(_, _, %{post: post}) do
    content =
      post.modified_gmt
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_iso8601()

    tag :meta, property: "article:modified_time", content: content
  end

  def modified_tag(_, _, _) do
    nil
  end

  def published_tag(conn, assigns), do: modified_tag(view_module(conn), view_template(conn), assigns)

  def published_tag(_, _, %{post: post}) do
    content =
      post.date_gmt
      |> DateTime.from_naive!("Etc/UTC")
      |> DateTime.to_iso8601()

    tag :meta, property: "article:published_time", content: content
  end

  def published_tag(_, _, _) do
    nil
  end
end
