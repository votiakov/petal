defmodule Content.PostsControllerTest do
  use Content.ConnCase

  alias Content
  alias Content.{Comment, Options, Posts, Repo, Term, TermRelationship, TermTaxonomy}

  @create_attrs %{
    id: 123,
    post_name: "my-post",
    post_title: "My Post",
    post_content: "Page One <!--nextpage--> Page Two",
    post_status: "publish",
    post_type: "post",
    post_date: "2018-01-01T00:00:00Z",
    comment_status: "open",
  }
  @blog_post_attrs %{
    id: 456,
    post_name: "my-blog-post",
    post_title: "My Blog Post",
    post_content: "Page One <!--nextpage--> Page Two",
    post_status: "publish",
    post_type: "post",
    post_date: "2018-01-01T00:00:00Z",
    comment_status: "open",
  }
  @preview_attrs %{
    post_name: "my-post",
    post_title: "My Post",
    post_content: "",
    post_status: "publish",
    post_type: "post",
    post_date: "2018-01-01T00:00:00Z"
  }
  @thumb_attrs %{
    id: 124,
    post_name: "my-thumb",
    post_title: "My Thumb",
    post_content: "",
    post_status: "publish",
    post_type: "attachment",
    post_date: "2018-01-01T00:00:00Z",
    guid: "http://placekitten.com/200/300"
  }
  @attachment_attrs %{
    id: 123,
    post_name: "attachment.txt",
    post_title: "",
    post_content: "my text attachment" |> Base.encode64,
    post_status: "publish",
    post_type: "attachment",
    post_mime_type: "text/plain",
    post_date: "2018-01-01T00:00:00Z",
    comment_status: "open",
  }
  @update_attrs %{post_name: "my-post"}
  @invalid_attrs %{post_status: "", post_type: "post"}

  @post_category %Term{
    term_id: 42,
    name: "Test Category",
    slug: "test-category",
  }

  @post_category_taxonomy %TermTaxonomy{
    term_taxonomy_id: 64,
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
    {:ok, _meta} = %Content.Postmeta{post_id: post.id, meta_key: "_thumbnail_id", meta_value: Integer.to_string(thumb.id)} |> Repo.insert()
    {:ok, _option} = %Content.Option{option_name: "sticky_posts", option_value: "a:1:{i:0;i:123;}"} |> Repo.insert()

    post
  end

  def fixture(:single_post) do
    {:ok, post} = Posts.create_posts(@create_attrs)
    {:ok, _comment} = %Comment{comment_post_id: post.id, comment_parent: 0, comment_date: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)} |> Repo.insert()
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
    {:ok, _option} = %Content.Option{option_name: "show_on_front", option_value: "page"} |> Repo.insert()
    {:ok, _option} = %Content.Option{option_name: "page_on_front", option_value: post.id |> Integer.to_string(10)} |> Repo.insert()

    post
  end

  def fixture(:blog_page) do
    {:ok, post} = Posts.create_posts(@create_attrs)
    {:ok, _blog} = Posts.create_posts(@blog_post_attrs)
    {:ok, _option} = %Content.Option{option_name: "page_for_posts", option_value: post.id |> Integer.to_string(10)} |> Repo.insert()

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

      assert html_response(conn, 200) =~ posts.post_title
    end

    test "shows the post by id", %{conn: conn, posts: posts} do
      conn = get conn, Routes.posts_path(conn, :show, posts.id)

      assert html_response(conn, 200) =~ posts.post_title
    end

    test "shows the post with pagination", %{conn: conn, posts: posts} do
      conn = get conn, Routes.paged_post_path(conn, :show, posts, "2")

      assert html_response(conn, 200) =~ posts.post_title
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
      page = fixture(:blog_page)
      conn = get conn, Routes.posts_path(conn, :show, page)

      assert html_response(conn, 200) =~ "My Blog Post"
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

      assert html_response(conn, 200) =~ @preview_attrs[:post_title]
    end

    test "shows the post (put method)", %{conn: conn} do
      conn =
        as_admin do
          put conn, Routes.posts_path(conn, :preview, %{"post" => @preview_attrs})
        end

      assert html_response(conn, 200) =~ @preview_attrs[:post_title]
    end
  end

  defp create_a_post(_) do
    post = fixture(:single_post)
    {:ok, posts: post}
  end

  defp create_posts(_) do
    posts = fixture(:posts)
    {:ok, posts: posts}
  end
end
