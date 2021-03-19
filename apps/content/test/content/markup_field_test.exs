defmodule Legendary.Content.MarkupFieldTest do
  use Legendary.Content.DataCase

  import Legendary.Content.MarkupField
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Form, only: [form_for: 3]

  def form do
    :example
    |> form_for(
      "/example",
      as: :test_params
    )
  end

  test "underlying db type is string" do
    assert type() == :string
  end

  test "cast string to markup field" do
    assert cast("foo") == {:ok, "foo"}
  end

  test "cast nonstring to markup field is an error" do
    assert cast(1) == :error
  end

  test "dump string from markup field" do
    assert dump("baz") == {:ok, "baz"}
  end

  test "dump nonstring from markup field is error" do
    assert dump(3) == :error
  end

  test "load value" do
    assert load("bar") == {:ok, "bar"}
  end

  test "render_form/5 makes a field with a simplemde data attribute" do
    safe = render_form(nil, nil, form(), :boop, %{})

    assert safe_to_string(safe) =~ "data-simplemde"
  end

  test "render_index/4 can render markdown" do
    markup = render_index(nil, %{text: "# Test"}, :text, [])

    assert markup =~ "<h1>"
    assert markup =~ "Test"
  end
end
