defmodule Content.OptionTest do
  use Content.DataCase

  alias Content.{Option, Repo}

  test "can save a new link" do
    %Option{}
    |> Option.changeset(%{
      option_name: "test_up",
      option_value: "1",
    })
    |> Repo.insert!()
  end
end
