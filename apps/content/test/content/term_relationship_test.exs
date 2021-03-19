defmodule Legendary.Content.TermRelationshipTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Repo, TermRelationship}

  test "can save a new term relationship" do
    %TermRelationship{}
    |> TermRelationship.changeset(%{
      object_id: 123,
      term_taxonomy_id: 456,
    })
    |> Repo.insert!()
  end
end
