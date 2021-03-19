defmodule Legendary.Content.PostsViewTest do
  use Legendary.Content.ConnCase

  import Legendary.Content.PostsView
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "auto_paragraph_tags/1 with nil" do
    assert safe_to_string(auto_paragraph_tags(nil)) =~ ""
  end

  test "auto_paragraph_tags/1 with text" do
    assert safe_to_string(auto_paragraph_tags("Bloop\n\nBloop")) =~ "<p>Bloop</p>\n<p>Bloop</p>"
  end
end
