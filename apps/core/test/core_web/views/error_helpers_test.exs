defmodule CoreWeb.ErrorHelpersTest do
  use Core.DataCase

  import CoreWeb.ErrorHelpers
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Form, only: [form_for: 3]
  import Ecto.Changeset, only: [cast: 3, add_error: 3]

  def form do
    :example
    |> form_for(
      "/example",
      as: :test_params,
      errors: [error_field: {"is an error", []}],
    )
  end

  test "error_class/2" do
    assert error_class(form, :error_field) == "error"
    assert error_class(form, :no_error_field) == ""
  end

  test "error_tag/3" do
    markup =
      form
      |> error_tag(:error_field, class: "foobar")
      |> Enum.at(0)
      |> safe_to_string()

    assert markup =~ "foobar"
    assert markup =~ "span"
    assert markup =~ "is an error"
  end
end
