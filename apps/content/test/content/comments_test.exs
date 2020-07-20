defmodule Content.CommentsTest do
  use Content.DataCase

  alias Content.{Comment, Comments, Repo}
  alias Ecto.Changeset

  def fixture(:parent_comment) do
    %Comment{
      comment_ID: 123,
      comment_content: "Hello world",
      comment_post_ID: 456,
    }
    |> Repo.insert!()
  end

  def fixture(:child_comment) do
    %Comment{
      comment_ID: 456,
      comment_parent: 123,
      comment_content: "Hello back",
      comment_post_ID: 456,
    }
    |> Repo.insert!()
  end

  describe "children" do
    test "can get children of a comment that has them" do
      parent = fixture(:parent_comment)
      kid = fixture(:child_comment)

      kids = Comments.children(parent.comment_ID, Comments.list_comments)
      assert kids == [kid]
    end

    test "returns an empty list if the comment has no children " do
      parent = fixture(:parent_comment)

      kids = Comments.children(parent.comment_ID, Comments.list_comments)
      assert kids == []
    end
  end

  describe "change comment" do
    test "gives a changeset" do
      changeset = fixture(:parent_comment) |> Comments.change_comment
      changed_value =
        changeset
        |> Changeset.put_change(:comment_content, "woops")
        |> Changeset.get_change(:comment_content)
      assert changed_value == "woops"
    end
  end
end
