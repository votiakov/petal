defmodule Content.AdminPostsControllerTest do
  use Content.ConnCase

  alias Content
  alias Content.Posts

  @create_attrs %{
    ID: 123,
    post_name: "my-post",
    post_title: "Post in the admin list",
    post_content: "",
    post_status: "publish",
    post_type: "post",
    post_date: "2018-01-01T00:00:00Z"
  }

  def fixture(:post) do
    {:ok, post} = Posts.create_posts(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      fixture(:post)

      conn =
        as_admin do
          get conn, Routes.admin_posts_path(conn, :index)
        end
      assert html_response(conn, 200) =~ "Post in the admin list"
    end

    test "lists all posts with page", %{conn: conn} do
      fixture(:post)

      conn =
        as_admin do
          get conn, Routes.admin_posts_path(conn, :index, page: "2")
        end
      assert html_response(conn, 200)
      refute html_response(conn, 200) =~ "Post in the admin list"
    end

    test "lists all posts with post type", %{conn: conn} do
      fixture(:post)

      conn =
        as_admin do
          get conn, Routes.admin_posts_path(conn, :index, post_type: "page")
        end
      assert html_response(conn, 200)
      refute html_response(conn, 200) =~ "Post in the admin list"
    end
  end
end
