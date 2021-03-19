defmodule Legendary.CoreWeb.EmailHelpersTest do
  use Legendary.Core.DataCase

  import Legendary.CoreWeb.EmailHelpers
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "framework_styles/0" do
    assert %{background: _, body: _} = framework_styles()
  end

  test "framework_styles/1" do
    assert framework_styles().background == framework_styles(:background)
  end

  test "application_styles/1" do
    assert %{} = application_styles(:background)
  end

  test "effective_styles/2" do
    assert %{color: "#FFF"} = effective_styles(:test, %{color: "#FFF"})
    assert Map.merge(framework_styles(:background), %{color: "#FFF"}) == effective_styles(:background, %{color: "#FFF"})
  end

  test "preview/1" do
    assert {:safe, [opening_tag, "test preview", _]} = preview do: "test preview"
    assert opening_tag =~ "<div"
  end

  test "header/1" do
    assert {:safe, _} = safe = header do: "Test Header!"

    assert safe_to_string(safe) =~ "Test Header!"
  end

  test "spacer/0" do
    assert {:safe, _} = spacer()
  end

  test "row/1" do
    assert {:safe, _} = safe = row do: "Row test"

    assert safe_to_string(safe) =~ "Row test"
  end

  test "col/3" do
    assert {:safe, _} = safe = col 1, [of: 2], do: "Column test"

    assert safe_to_string(safe) =~ "Column test"
    assert safe_to_string(safe) =~ "width=\"50.0%\""
  end

  test "hero_image/1" do
    assert {:safe, _} = safe = hero_image(src: "src.jpg")

    assert safe_to_string(safe) =~ "src.jpg"
    assert safe_to_string(safe) =~ "<img"
  end

  test "h1/1" do
    assert {:safe, _} = safe = h1 do: "H1 Test!"

    assert safe_to_string(safe) =~ "H1 Test!"
  end

  test "h2/1" do
    assert {:safe, _} = safe = h2 do: "H2 Test!"

    assert safe_to_string(safe) =~ "H2 Test!"
  end

  test "p/1" do
    assert {:safe, _} = safe = p do: "This is the test paragraph."

    assert safe_to_string(safe) =~ "This is the test paragraph."
  end

  test "button/2" do
    assert {:safe, _} = safe = button [href: "http://duckduckgo.com"], do: "Button text!"

    assert safe_to_string(safe) =~ "duckduckgo.com"
    assert safe_to_string(safe) =~ "Button text!"
  end

  test "ul/1" do
    markup = safe_to_string(ul(items: ["First item", "Second item"]))

    assert markup =~ "<li"
    assert markup =~ "First item"
    assert markup =~ "Second item"
  end

  test "footer/0" do
    markup = safe_to_string(footer())

    assert markup =~ Legendary.I18n.t! "en", "email.company.name"
  end
end
