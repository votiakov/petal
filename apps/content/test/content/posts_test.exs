defmodule Content.PostsTest do
  use Content.DataCase

  alias Content.{Post, Posts, Repo}

  setup do
    admin_only_post =
      %Post{
        title: "Admin-only post",
        name: "admin-only-post",
        status: "draft",
        type: "post",
        date: ~N[2020-02-01T00:00:00],
      }
      |> Repo.insert!()

    public_post =
      %Post{
        title: "Public post",
        name: "public-post",
        status: "publish",
        type: "post",
        date: ~N[2020-01-01T00:00:00],
      }
      |> Repo.insert!()

    %{
      admin_only_post: admin_only_post,
      public_post: public_post,
    }
  end

  test "list_admin_posts/2" do
    results = Posts.list_admin_posts("1")

    assert Enum.count(results) == 2
    assert [%{name: "admin-only-post"}, %{name: "public-post"}] = results
  end

  test "get_post_with_drafts!/1 with slug" do
    assert %Post{} = Posts.get_post_with_drafts!("admin-only-post")
  end

  test "get_post_with_drafts!/1 with id", %{admin_only_post: %{id: id}} do
    assert %Post{} = Posts.get_post_with_drafts!(Integer.to_string(id))
  end

  test "update_posts/2", %{public_post: post} do
    assert {:ok, %Post{content: "boop"}} = Posts.update_posts(post, %{content: "boop"})
  end

  test "delete_posts/1", %{public_post: post} do
    assert Enum.count(Posts.list_posts()) == 1
    assert {:ok, _} = Posts.delete_posts(post)
    assert Enum.count(Posts.list_posts()) == 0
  end

  test "change_posts/1", %{public_post: post} do
    assert %{data: %Post{name: "public-post"}} = Posts.change_posts(post)
  end
end
