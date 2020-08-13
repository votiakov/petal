defmodule Core.MapUtilsTest do
  use Core.DataCase

  import Core.MapUtils

  test "deep_merge/2" do
    assert deep_merge(
      %{
        profile: %{first: "George", last: "Washington"}
      },
      %{
        profile: %{last: "Harrison"}
      }
    ) == %{profile: %{first: "George", last: "Harrison"}}
  end
end
