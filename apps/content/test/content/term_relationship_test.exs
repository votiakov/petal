defmodule Content.TermRelationshipTest do
  use Content.DataCase

  alias Content.{Repo, TermRelationship}

  test "can save a new term relationship" do
    %TermRelationship{}
    |> TermRelationship.changeset(%{
      object_id: 123,
      term_taxonomy_id: 456,
    })
    |> Repo.insert!()
  end
end
