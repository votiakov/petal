defmodule Content.PostmetaTest do
  use Content.DataCase

  alias Content.{Postmeta, Repo}

  test "can save a new postmeta" do
    %Postmeta{}
    |> Postmeta.changeset(%{
      post_id: 123,
      meta_key: "testpostmeta",
      meta_value: "some value",
    })
    |> Repo.insert!()
  end
end
