defmodule Legendary.Content.CommentsTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Comment, Comments, Repo}
  alias Ecto.Changeset

  def fixture(:parent_comment) do
    %Comment{
      id: 123,
      content: "Hello world",
      post_id: 456,
    }
    |> Repo.insert!()
  end

  def fixture(:child_comment) do
    %Comment{
      id: 456,
      parent: 123,
      content: "Hello back",
      post_id: 456,
    }
    |> Repo.insert!()
  end

  describe "children" do
    test "can get children of a comment that has them" do
      parent = fixture(:parent_comment)
      kid = fixture(:child_comment)

      kids = Comments.children(parent.id, Comments.list_comments)
      assert kids == [kid]
    end

    test "returns an empty list if the comment has no children " do
      parent = fixture(:parent_comment)

      kids = Comments.children(parent.id, Comments.list_comments)
      assert kids == []
    end
  end

  describe "change comment" do
    test "gives a changeset" do
      changeset = fixture(:parent_comment) |> Comments.change_comment
      changed_value =
        changeset
        |> Changeset.put_change(:content, "woops")
        |> Changeset.get_change(:content)
      assert changed_value == "woops"
    end
  end
end
