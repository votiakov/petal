defmodule CoreWeb.HelpersTest do
  use CoreWeb.ConnCase

  import CoreWeb.Helpers
  import Ecto.Changeset,
    only: [cast: 3, validate_required: 2, apply_action: 2]
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Form, only: [form_for: 3]

  def form do
    :example
    |> form_for(
      "/example",
      as: :test_params,
      errors: [error_field: {"is an error", []}]
    )
  end

  def changeset(:error) do
    {:error, changeset} =
      {%{name: nil}, %{name: :string}}
      |> cast(%{}, [:name])
      |> validate_required(:name)
      |> apply_action(:update)

    changeset
  end

  def changeset(:success) do
    {:ok, changeset} =
      {%{name: nil}, %{name: :string}}
      |> cast(%{}, [:name])
      |> apply_action(:update)

    changeset
  end

  describe "has_role?/2" do
    test "with a user", %{conn: conn} do
      conn =
        conn
        |> Pow.Plug.put_config(current_user_assigns_key: :current_user)
        |> Pow.Plug.assign_current_user(%Auth.User{roles: ["admin"]}, [])

      assert has_role?(conn, "admin")
      refute has_role?(conn, "blooper")
    end

    test "without a user", %{conn: conn} do
      conn =
        conn
        |> Pow.Plug.put_config(current_user_assigns_key: :current_user)

      refute has_role?(conn, "admin")
    end
  end

  test "changeset_error_block/1" do
    markup =
      :error
      |> changeset()
      |> changeset_error_block()
      |> safe_to_string()

    assert markup =~ "Please check the errors below."
  end

  test "flash_block/1", %{conn: conn} do
    markup =
      conn
      |> init_test_session([])
      |> fetch_flash()
      |> put_flash(:error, "The server melted.")
      |> flash_block()
      |> safe_to_string()

    assert markup =~ "js-flash"
  end

  test "styled_input/4 (without error)" do
    markup = safe_to_string(styled_input(form(), :no_error_field))

    assert markup =~ "<input"
    assert markup =~ "<label"
  end

  test "styled_input/4 (with error)" do
    markup = safe_to_string(styled_input(form(), :error_field))

    assert markup =~ "<input"
    assert markup =~ "<label"
  end

  test "styled_input/5 with content" do
    config = [input_helper: :select, label: "Mode"]
    options = [{"Test", 1}]

    markup =
      styled_input(form(), :no_error_field, config, options) do

      end
      |> safe_to_string()

    assert markup =~ "<select"
    assert markup =~ "<label"
  end

  test "pow_extension_enabled?/1" do
    assert pow_extension_enabled?(PowEmailConfirmation) == true
    assert pow_extension_enabled?(:donkdonk) == false
  end
end
