defmodule Content.TermTest do
  use Content.DataCase

  alias Content.{Repo, Term}

  test "can save a new term" do
    %Term{}
    |> Term.changeset(%{
      slug: "testterm",
      name: "Test Term",
    })
    |> Repo.insert!()
  end
end
