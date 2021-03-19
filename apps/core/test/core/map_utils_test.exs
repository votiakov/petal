defmodule Legendary.Core.MapUtilsTest do
  use Legendary.Core.DataCase

  import Legendary.Core.MapUtils

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
