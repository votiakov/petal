defmodule Content.CommentmetaTest do
  use Content.DataCase

  alias Content.{Commentmeta, Repo}

  test "can save a new commentmeta" do
    %Commentmeta{}
    |> Commentmeta.changeset(%{
      comment_id: 123,
      meta_key: "testcommentmeta",
      meta_value: "some value",
    })
    |> Repo.insert!()
  end
end
