defmodule Legendary.Content.PostsControllerTest do
  use Legendary.Content.ConnCase

  alias Legendary.Content.{Comment, Options, Post, Posts, Repo, Term, TermRelationship, TermTaxonomy}

  @create_attrs %{
    id: 123,
    name: "my-post",
    title: "My Post",
    content: "Page One <!--nextpage--> Page Two",
    status: "publish",
    type: "post",
    date: "2018-01-01T00:00:00Z",
    comment_status: "open",
  }
  @preview_attrs %{
    name: "my-post",
    title: "My Post",
    content: "",
    status: "publish",
    type: "post",
    date: "2018-01-01T00:00:00Z"
  }
  @thumb_attrs %{
    id: 124,
    name: "my-thumb",
    title: "My Thumb",
    content: "",
    status: "publish",
    type: "attachment",
    date: "2018-01-01T00:00:00Z",
    guid: "http://placekitten.com/200/300"
  }
  @attachment_attrs %{
    id: 123,
    name: "attachment.txt",
    title: "",
    content: "my text attachment" |> Base.encode64,
    status: "publish",
    type: "attachment",
    mime_type: "text/plain",
    date: "2018-01-01T00:00:00Z",
    comment_status: "open",
  }

  @post_category %Term{
    id: 42,
    name: "Test Category",
    slug: "test-category",
  }

  @post_category_taxonomy %TermTaxonomy{
    id: 64,
    term_id: 42,
    taxonomy: "category",
    description: "A test category",
    parent: 0,
  }

  @post_category_relationship %TermRelationship{
    term_taxonomy_id: 64,
    object_id: 123,
  }

  def fixture(:posts) do
    {:ok, post} = Posts.create_posts(@create_attrs)
    {:ok, thumb} = Posts.create_posts(@thumb_attrs)
    {:ok, _meta} = %Legendary.Content.Postmeta{post_id: post.id, key: "_thumbnail_id", value: Integer.to_string(thumb.id)} |> Repo.insert()
    {:ok, _option} = %Legendary.Content.Option{name: "sticky_posts", value: "a:1:{i:0;i:123;}"} |> Repo.insert()

    post
  end

  def fixture(:single_post) do
    {:ok, post} = Posts.create_posts(@create_attrs)
    {:ok, _comment} = %Comment{post_id: post.id, parent: 0, date: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)} |> Repo.insert()
    post
  end

  def fixture(:category) do
    {:ok, category} = @post_category |> Repo.insert()
    {:ok, _term_taxonomy} = @post_category_taxonomy |> Repo.insert()
    {:ok, _term_relationship} = @post_category_relationship |> Repo.insert()
    category
  end

  def fixture(:front_post) do
    {:ok, post} = Posts.create_posts(@create_attrs)
    {:ok, _option} = %Legendary.Content.Option{name: "show_on_front", value: "page"} |> Repo.insert()
    {:ok, _option} = %Legendary.Content.Option{name: "page_on_front", value: post.id |> Integer.to_string(10)} |> Repo.insert()

    post
  end

  def fixture(:attachment) do
    {:ok, post} = Posts.create_posts(@attachment_attrs)

    post
  end

  describe "index" do
    test "lists all posts when posts on front is set", %{conn: conn} do
      Options.put("show_on_front", "posts")
      fixture(:posts)

      conn = get conn, Routes.posts_path(conn, :index)
      assert html_response(conn, 200) =~ "My Post"
    end

    test "lists all posts by category", %{conn: conn} do
      fixture(:posts)
      fixture(:category)

      conn = get conn, Routes.category_path(conn, :index_posts, @post_category.slug)
      assert html_response(conn, 200) =~ "My Post"
    end

    test "lists all posts by category page", %{conn: conn} do
      fixture(:posts)
      fixture(:category)

      conn = get conn, Routes.category_page_path(conn, :index, @post_category.slug, "2")
      assert html_response(conn, 200)
    end

    test "lists all posts for page", %{conn: conn} do
      fixture(:posts)

      conn = get conn, Routes.blog_page_path(conn, :index_posts, "2")
      assert html_response(conn, 200)
    end

    test "shows a page if it is set as the front page", %{conn: conn} do
      fixture(:front_post)

      conn = get conn, Routes.posts_path(conn, :index)
      assert html_response(conn, 200) =~ "Page One"
    end
  end

  describe "show a post" do
    setup [:create_a_post]

    test "shows the post", %{conn: conn, posts: posts} do
      conn = get conn, Routes.posts_path(conn, :show, posts)

      assert html_response(conn, 200) =~ posts.title
    end

    test "shows the post by id", %{conn: conn, posts: posts} do
      conn = get conn, Routes.posts_path(conn, :show, posts.id)

      assert html_response(conn, 200) =~ posts.title
    end

    test "shows the post with pagination", %{conn: conn, posts: posts} do
      conn = get conn, Routes.posts_path(conn, :show, posts, page: "2")

      assert html_response(conn, 200) =~ posts.title
    end

    test "show a static page", %{conn: conn} do
      conn = get conn, Routes.posts_path(conn, :show, "index")

      assert html_response(conn, 200)
    end

    test "shows the post if the id has slashes", %{conn: conn} do
      %Post{
        name: "a/b/c",
        content: "slashed id",
        status: "publish",
        type: "post",
        date: ~N[2020-01-01T00:00:00]
      }
      |> Repo.insert!()

      conn = get conn, Routes.nested_posts_path(conn, :show, ["a", "b", "c"])

      assert html_response(conn, 200)
    end

    test "show a 404 if there's no match", %{conn: conn} do
      assert_raise Phoenix.Router.NoRouteError, fn ->
        get conn, Routes.posts_path(conn, :show, "blooper")
      end
    end
  end

  describe "show the front post" do
    test "shows the post if it is the front post", %{conn: conn} do
      post = fixture(:front_post)
      conn = get conn, Routes.posts_path(conn, :show, post)

      assert html_response(conn, 200) =~ "Page One"
    end
  end

  describe "show the blog_page" do
    test "shows the post if it is the front post", %{conn: conn} do
      post = fixture(:single_post)
      conn = get conn, Routes.posts_path(conn, :show, "blog")

      assert html_response(conn, 200) =~ post.title
    end
  end

  describe "show an attachment post" do
    test "shows the post", %{conn: conn} do
      post = fixture(:attachment)
      conn = get conn, Routes.posts_path(conn, :show, post)

      assert text_response(conn, 200) =~ "my text attachment"
    end
  end

  describe "preview a post" do
    test "shows the post (post method)", %{conn: conn} do
      conn =
        as_admin do
          post conn, Routes.posts_path(conn, :preview, %{"post" => @preview_attrs})
        end

      assert html_response(conn, 200) =~ @preview_attrs[:title]
    end

    test "shows the post (put method)", %{conn: conn} do
      conn =
        as_admin do
          put conn, Routes.posts_path(conn, :preview, %{"post" => @preview_attrs})
        end

      assert html_response(conn, 200) =~ @preview_attrs[:title]
    end
  end

  defp create_a_post(_) do
    post = fixture(:single_post)
    {:ok, posts: post}
  end
end
