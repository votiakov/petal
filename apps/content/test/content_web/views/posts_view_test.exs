defmodule Legendary.Content.PostsViewTest do
  use Legendary.Content.ConnCase

  import Legendary.Content.PostsView
  import Phoenix.HTML, only: [safe_to_string: 1]

  alias Legendary.Content.Post

  test "auto_paragraph_tags/1 with nil" do
    assert safe_to_string(auto_paragraph_tags(nil)) =~ ""
  end

  test "auto_paragraph_tags/1 with text" do
    assert safe_to_string(auto_paragraph_tags("Bloop\n\nBloop")) =~ "<p>Bloop</p>\n<p>Bloop</p>"
  end

  describe "authenticated_for_post?/2" do
    test "without password" do
      assert authenticated_for_post?(nil, %Post{})
    end

    test "with post password that matches", %{conn: conn} do
      with_mock Plug.Conn, [get_session: fn (_conn, :post_password) -> "password" end] do
        assert authenticated_for_post?(conn, %Post{password: "password"})
      end
    end

    test "with post password that does not match", %{conn: conn} do
      with_mock Plug.Conn, [get_session: fn (_conn, :post_password) -> "password" end] do
        refute authenticated_for_post?(conn, %Post{password: "password2"})
      end
    end
  end
end
