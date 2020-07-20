defmodule Content.SlugsTest do
  use Content.DataCase

  alias Content.{Post, Posts, Repo, Slugs}
  alias Ecto.Changeset

  @create_attrs %{
    ID: 123,
    post_name: "my-post",
    post_title: "My Post",
    post_content: "",
    post_status: "publish",
    post_type: "post",
    post_date: "2018-01-01T00:00:00Z"
  }

  @dupe_title_attrs %{
    ID: 456,
    post_title: "My Post",
    post_content: "",
    post_status: "publish",
    post_type: "post",
    post_date: "2018-01-01T00:00:00Z"
  }

  describe "ensure_post_has_slug" do
    test "doesn't overwrite a set slug" do
      new_post =
        %Post{
          post_name: "a-set-slug"
        }
        |> Post.changeset()
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.post_name == "a-set-slug"
    end

    test "works even if the title is nil" do
      new_post =
        %Post{}
        |> Changeset.change(%{})
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.post_name |> String.length() > 0
    end

    test "sets a slug if the title is there" do
      new_post =
        %Post{
          post_title: "My NEW Post"
        }
        |> Changeset.change(%{})
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.post_name == "my-new-post"
    end

    test "ensures uniqueness of the slug" do
      {:ok, og_post} = Posts.create_posts(@create_attrs)
      assert Post |> Repo.aggregate(:count, :ID) == 1

      new_post =
        %Post{
          post_title: "MY POST"
        }
        |> Changeset.change(%{})
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.post_name != og_post.post_name
      assert new_post.post_name == "my-post-1"
    end

    test "ensures uniqueness of the slug on update" do
      {:ok, og_post} = Posts.create_posts(@create_attrs)
      assert Post |> Repo.aggregate(:count, :ID) == 1

      new_post =
        %Post{}
        |> Changeset.change(@dupe_title_attrs)
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.post_name != og_post.post_name
      assert new_post.post_name == "my-post-1"
    end
  end
end
