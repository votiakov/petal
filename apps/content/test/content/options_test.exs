defmodule Content.OptionsTest do
  use Content.DataCase

  alias Content.{Option, Options, Repo}

  def fixture(:option) do
    %Option{}
    |> Option.changeset(%{
      option_name: "test_up",
      option_value: "1",
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
