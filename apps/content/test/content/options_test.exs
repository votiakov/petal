defmodule Legendary.Content.OptionsTest do
  use Legendary.Content.DataCase

  alias Legendary.Content.{Option, Options, Repo}

  def fixture(:option) do
    %Option{}
    |> Option.changeset(%{
      name: "test_up",
      value: "1",
    })
    |> Repo.insert!()
  end

  test "can get an option by name" do
    fixture(:option)

    assert Options.get_value("test_up") == "1"
  end

  test "can get an option by name as an int" do
    fixture(:option)

    assert Options.get_value_as_int("test_up") == {1, ""}
  end
end
