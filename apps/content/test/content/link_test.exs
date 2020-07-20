defmodule Content.LinkTest do
  use Content.DataCase

  alias Content.{Link, Repo}

  test "can save a new link" do
    %Link{}
    |> Link.changeset(%{
      link_url: "https://example.com"
    })
    |> Repo.insert!()
  end
end
