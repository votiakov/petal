defmodule Content.TermmetaTest do
  use Content.DataCase

  alias Content.{Repo, Termmeta}

  test "can save a new termmeta" do
    %Termmeta{}
    |> Termmeta.changeset(%{
      term_id: 123,
      key: "testtermmeta",
      value: "some value",
    })
    |> Repo.insert!()
  end
end
