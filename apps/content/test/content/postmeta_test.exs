defmodule Content.PostmetaTest do
  use Content.DataCase

  alias Content.{Postmeta, Repo}

  test "can save a new postmeta" do
    %Postmeta{}
    |> Postmeta.changeset(%{
      post_id: 123,
      key: "testpostmeta",
      value: "some value",
    })
    |> Repo.insert!()
  end
end
