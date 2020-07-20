defmodule Content.TermTaxonomyTest do
  use Content.DataCase

  alias Content.{Repo, TermTaxonomy}

  test "can save a new term taxonomy" do
    %TermTaxonomy{}
    |> TermTaxonomy.changeset(%{
      taxonomy: "post_tag",
    })
    |> Repo.insert!()
  end
end
