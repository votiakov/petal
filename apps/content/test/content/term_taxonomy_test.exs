defmodule Legendary.Content.TermTaxonomyTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Repo, TermTaxonomy}

  test "can save a new term taxonomy" do
    %TermTaxonomy{}
    |> TermTaxonomy.changeset(%{
      taxonomy: "post_tag",
    })
    |> Repo.insert!()
  end
end
