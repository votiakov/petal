defmodule Content.CommentControllerTest do
  use Content.ConnCase

  alias Content.Comments
  alias Content.Posts

  @post_attrs %{id: 456, post_name: "blergh", post_status: "publish"}
  @create_attrs %{comment_id: 123, comment_content: "Hello world", comment_post_id: 456}
  @update_attrs %{comment_id: 123, comment_content: "Goodbye", comment_post_id: 456}
  @invalid_attrs %{comment_id: 123, comment_content: "", comment_post_id: 456}

  def fixture(:post) do
    {:ok, post} = Posts.create_posts(@post_attrs)
    post
  end

  def fixture(:comment) do
    {:ok, comment} = Comments.create_comment(@create_attrs)
    comment
  end

  describe "create comment" do
    test "redirects to show when data is valid", %{conn: conn} do
      post = fixture(:post)
      conn = post conn, Routes.comment_path(conn, :create), comment: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      post = fixture(:post)
      conn = post conn, Routes.comment_path(conn, :create), comment: @invalid_attrs
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post)
    end
  end

  describe "update comment" do
    setup [:create_comment]

    test "redirects when data is valid", %{conn: conn, comment: comment, post: post} do
      conn = put conn, Routes.comment_path(conn, :update, comment), comment: @update_attrs
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post)
    end

    test "renders errors when data is invalid", %{conn: conn, comment: comment, post: post} do
      conn = put conn, Routes.comment_path(conn, :update, comment), comment: @invalid_attrs
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post)
    end
  end

  describe "delete comment" do
    setup [:create_comment]

    test "deletes chosen comment", %{conn: conn, comment: comment, post: post} do
      conn = delete conn, Routes.comment_path(conn, :delete, comment)
      assert redirected_to(conn) == Routes.posts_path(conn, :show, post)
    end
  end

  defp create_comment(_) do
    comment = fixture(:comment)
    post = fixture(:post)
    {:ok, comment: comment, post: post}
  end
end
