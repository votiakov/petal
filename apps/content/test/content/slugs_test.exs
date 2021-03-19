defmodule Legendary.Content.SlugsTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Post, Posts, Repo, Slugs}
  alias Ecto.Changeset

  @create_attrs %{
    id: 123,
    name: "my-post",
    title: "My Post",
    content: "",
    status: "publish",
    type: "post",
    date: "2018-01-01T00:00:00Z"
  }

  @dupe_title_attrs %{
    id: 456,
    title: "My Post",
    content: "",
    status: "publish",
    type: "post",
    date: "2018-01-01T00:00:00Z"
  }

  describe "ensure_post_has_slug" do
    test "doesn't overwrite a set slug" do
      new_post =
        %Post{
          name: "a-set-slug"
        }
        |> Post.changeset()
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.name == "a-set-slug"
    end

    test "works even if the title is nil" do
      new_post =
        %Post{}
        |> Changeset.change(%{})
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.name |> String.length() > 0
    end

    test "sets a slug if the title is there" do
      new_post =
        %Post{
          title: "My NEW Post"
        }
        |> Changeset.change(%{})
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.name == "my-new-post"
    end

    test "ensures uniqueness of the slug" do
      {:ok, og_post} = Posts.create_posts(@create_attrs)
      assert Post |> Repo.aggregate(:count, :id) == 1

      new_post =
        %Post{
          title: "MY POST"
        }
        |> Changeset.change(%{})
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.name != og_post.name
      assert new_post.name == "my-post-1"
    end

    test "ensures uniqueness of the slug on update" do
      {:ok, og_post} = Posts.create_posts(@create_attrs)
      assert Post |> Repo.aggregate(:count, :id) == 1

      new_post =
        %Post{}
        |> Changeset.change(@dupe_title_attrs)
        |> Slugs.ensure_post_has_slug()
        |> Changeset.apply_changes()

      assert new_post.name != og_post.name
      assert new_post.name == "my-post-1"
    end
  end
end
