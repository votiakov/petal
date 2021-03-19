defmodule Legendary.Content.OptionTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Option, Repo}

  test "can save a new link" do
    %Option{}
    |> Option.changeset(%{
      name: "test_up",
      value: "1",
    })
    |> Repo.insert!()
  end
end
