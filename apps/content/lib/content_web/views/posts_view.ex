defmodule Legendary.Content.PostsView do
  use Legendary.Content, :view
  use Phoenix.HTML
  import Plug.Conn
  alias Legendary.Content.Comment
  alias Legendary.Content.Post
  alias Phoenix.HTML
  alias Phoenix.HTML.Tag

  def paginated_posts_path(conn, category, page) do
    case category do
      nil ->
        Routes.blog_page_path(conn, :index_posts, page)
      _ ->
        Routes.category_page_path(conn, :index, category, page)
    end
  end

  def authenticated_for_post?(conn, post) do
    post.password == nil || String.length(post.password) == 0 || get_session(conn, :post_password) == post.password
  end

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

  def comment_changeset_for_post(%Post{} = post) do
    %Comment{
      post_id: post.id
    }
    |> Comment.changeset()
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
      %Legendary.Auth.User{
        email: "example@example.org",
        display_name: "Anonymous",
        homepage_url: "#"
      }
    assigns = %{post: post, author: author, conn: conn}
    ~E"""
      <% _ = assigns # suppress unused assigns warning %>
      <div class="flex w-full items-center font-sans py-6">
        <%= link to: author.homepage_url || "#", rel: "author", class: "p-author h-card" do %>
        <%= img_tag gravatar_url_for_email(author.email), alt: "Photo of #{author.display_name}", class: "Gravatar u-photo w-10 h-10 rounded-full mr-4" %>
        <div class="flex-1 px-2">
          <p class="text-base font-bold text-base md:text-xl leading-none mb-2">
            <%= author.display_name %>
          </p>
          <%= link to: Routes.posts_path(conn, :show, post) do %>
            <p class="text-gray-600 text-xs md:text-base">
              Published
              <time class="dt-published" datetime="<%= post.date %>">
                <%= post.date |> Timex.format!("%F", :strftime) %>
              </time>
            </p>
          <% end %>
        </div>
      <% end %>
      </div>
    """
  end
end
