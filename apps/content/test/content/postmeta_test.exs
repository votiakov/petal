defmodule Legendary.Content.PostmetaTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Postmeta, Repo}

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
