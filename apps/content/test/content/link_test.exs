defmodule Legendary.Content.LinkTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Link, Repo}

  test "can save a new link" do
    %Link{}
    |> Link.changeset(%{
      link_url: "https://example.com"
    })
    |> Repo.insert!()
  end
end
