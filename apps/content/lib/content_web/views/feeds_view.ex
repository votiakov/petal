defmodule Content.FeedsView do
  use Content, :view
  use Phoenix.HTML
  alias Phoenix.HTML
  alias Phoenix.HTML.Tag
  alias Content.LayoutView

  def gravatar_url_for_email(email) do
    email
    |> Kernel.||("noreply@example.com")
    |> String.trim()
    |> String.downcase()
    |> (&(:crypto.hash(:md5, &1))).()
    |> Base.encode16()
    |> String.downcase()
    |> (&("https://www.gravatar.com/avatar/#{&1}")).()
  end

  def auto_paragraph_tags(string) do
    string
    |> Kernel.||("")
    |> String.split(["\n\n", "\r\n\r\n"], trim: true)
    |> Enum.map(fn text ->
      [Tag.content_tag(:p, text |> HTML.raw(), []), ?\n]
    end)
    |> HTML.html_escape()
  end

  def post_class(post) do
    sticky =
      if post.sticky do
        "sticky"
      end
    "post post-#{post.id} #{sticky}"
  end

  def post_topmatter(conn, post) do
    author =
      post.author ||
      %Auth.User{
        email: "example@example.org",
        display_name: "Anonymous",
        homepage_url: "#"
      }
    assigns = %{post: post, author: author, conn: conn}
    ~E"""
      <% _ = assigns # suppress unused assigns warning %>
      <div class="Comment-topmatter">

        <h4>
          <%= link to: author.homepage_url || "#", rel: "author", class: "p-author h-card" do %>
            <%= author.display_name %>
            <%= img_tag gravatar_url_for_email(author.email), alt: "Photo of #{author.display_name}", class: "Gravatar u-photo" %>
          <% end %>
        </h4>
        <h5>
          <%= link to: Routes.posts_path(conn, :show, post) do %>
            <time class="dt-published" datetime="<%= post.post_date %>">
              <%= post.post_date |> Timex.format!("%F", :strftime) %>
            </time>
          <% end %>
        </h5>
      </div>
    """
  end

  def unauthenticated_post?(_conn, post) do
    post.post_password == nil || String.length(post.post_password) == 0
  end
end
