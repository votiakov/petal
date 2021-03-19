defmodule Legendary.Content.AttachmentTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Attachment, Postmeta, Posts, Repo}

  @create_attrs %{
    id: 123,
    name: "my-attachment",
    title: "My Attachment",
    content: "",
    status: "publish",
    type: "attachment",
    date: "2018-01-01T00:00:00Z"
  }

  def fixture(:wide_attachment) do
    {:ok, attachment} = Posts.create_posts(@create_attrs)
    {:ok, _meta} =
      %Postmeta{
        post_id: attachment.id,
        key: "attachment_metadata",
        value: "a:2:{s:5:\"width\";i:640;s:6:\"height\";i:480;}"
      } |> Repo.insert()

    Legendary.Content.Post
    |> preload([:metas])
    |> Repo.get!(attachment.id)
  end

  def fixture(:tall_attachment) do
    {:ok, attachment} = Posts.create_posts(@create_attrs)
    {:ok, _meta} =
      %Postmeta{
        post_id: attachment.id,
        key: "attachment_metadata",
        value: "a:2:{s:5:\"width\";i:480;s:6:\"height\";i:640;}"
      } |> Repo.insert()
    Legendary.Content.Post
    |> preload([:metas])
    |> Repo.get!(attachment.id)
  end

  def fixture(:unknown_dimensions) do
    {:ok, attachment} = Posts.create_posts(@create_attrs)
    Legendary.Content.Post
    |> preload([:metas])
    |> Repo.get!(attachment.id)
  end

  describe "dimensions" do
    test "can get dimensions" do
      assert Attachment.dimensions(fixture(:wide_attachment)) == %{width: 640, height: 480}
    end

    test "returns nil if dimensions are missing" do
      assert is_nil(Attachment.dimensions(fixture(:unknown_dimensions)))
    end
  end

  describe "vertical?" do
    test "returns true if vertical image" do
      assert Attachment.vertical?(fixture(:tall_attachment))
    end

    test "returns false if not vertical image" do
      refute Attachment.vertical?(fixture(:wide_attachment))
    end
  end
end
