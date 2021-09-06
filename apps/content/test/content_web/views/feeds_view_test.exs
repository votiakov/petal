defmodule Legendary.Content.FeedsViewTest do
  use Legendary.Content.DataCase

  import Legendary.Content.FeedsView

  alias Legendary.Content.Post

  describe "unauthenticated_post?/1" do
    test "with post password" do
      refute unauthenticated_post?(%Post{password: "password"})
    end

    test "without post password" do
      assert unauthenticated_post?(%Post{})
    end
  end
end
