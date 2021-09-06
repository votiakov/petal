defmodule AppWeb.ErrorHelpersTest do
  use AppWeb.ConnCase

  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Form, only: [form_for: 3]

  import AppWeb.ErrorHelpers

  def form do
    :example
    |> form_for(
      "/example",
      as: :test_params,
      errors: [error_field: {"is an error", []}]
    )
  end

  describe "error_tag/2" do
    test "generates a span with an invalid-feedback class" do
      [safe] = error_tag(form(), :error_field)
      assert safe_to_string(safe) =~ "invalid-feedback"
    end

    test "error_tag/3" do
      [safe] = error_tag(form(), :error_field, class: "test-class")
      assert safe_to_string(safe) =~ "test-class"
    end
  end
end
