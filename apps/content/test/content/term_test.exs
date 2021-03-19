defmodule Legendary.Content.TermTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Repo, Term}

  test "can save a new term" do
    %Term{}
    |> Term.changeset(%{
      slug: "testterm",
      name: "Test Term",
    })
    |> Repo.insert!()
  end
end
