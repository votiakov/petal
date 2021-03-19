defmodule Legendary.Admin.ErrorHelpersTest do
  use Legendary.Admin.ConnCase

  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Form, only: [form_for: 3]

  import Legendary.Admin.ErrorHelpers

  def form do
    :example
    |> form_for(
      "/example",
      as: :test_params,
      errors: [error_field: {"is an error", []}]
    )
  end

  test "error_tag/2" do
    [safe] = error_tag(form(), :error_field)
    assert safe_to_string(safe) =~ "invalid-feedback"
  end

  test "error_tag/3" do
    [safe] = error_tag(form(), :error_field, class: "test-class")
    assert safe_to_string(safe) =~ "test-class"
  end

  test "translate_error/1" do
    assert translate_error({"is an error", []}) == "is an error"
    assert translate_error({"%{count} errors", %{count: 3}}) == "3 errors"
  end
end
