defmodule Content.OptionTest do
  use Content.DataCase

  alias Content.{Option, Repo}

  test "can save a new link" do
    %Option{}
    |> Option.changeset(%{
      name: "test_up",
      value: "1",
    })
    |> Repo.insert!()
  end
end
