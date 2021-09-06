defmodule Legendary.CoreWeb.HelpersTest do
  use Legendary.CoreWeb.ConnCase, async: true

  import Legendary.CoreWeb.Helpers
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

  describe "current_user?/1" do
    test "returns nil for a conn with no user", %{conn: conn}, do: refute conn |> setup_pow() |> current_user()
    test "returns a user for a conn with a user", %{conn: conn} do
      conn =
        conn
        |> setup_user(id: 456)

      assert current_user(conn).id == 456
    end
  end

  describe "has_role?/2" do
    test "with a user", %{conn: conn} do
      conn =
        conn
        |> Pow.Plug.put_config(current_user_assigns_key: :current_user)
        |> Pow.Plug.assign_current_user(%Legendary.Auth.User{roles: ["admin"]}, [])

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

  test "styled_input for date_select" do
    markup =
      form()
      |> styled_input(:no_error_field, type: :date_select)
      |> safe_to_string()

    assert markup =~ "<select"
  end

  describe "styled_button/1" do
    test "makes a button with content" do
      markup =
        styled_button("Push Me")
        |> safe_to_string()

      assert markup =~ ">Push Me"
      assert markup =~ "<button"
    end
  end

  describe "styled_button_link/2" do
    test "makes a link with content and attributes" do
      markup =
        styled_button_link("Push Me", to: "#anchor")
        |> safe_to_string()

      assert markup =~ ">Push Me"
      assert markup =~ "<a"
      assert markup =~ ~s(href="#anchor")
    end
  end

  describe "paginator/3" do
    def reflector(range, current), do: {range, current}

    test "works with only one page" do
      assert paginator(1..1, 1, &reflector/2) == [{1..1, 1}]
    end

    test "works with two pages" do
      assert paginator(1..2, 1, &reflector/2) == [{1..2, 1}, {1..2, 2}]
    end

    test "works with three pages" do
      assert paginator(1..3, 3, &reflector/2) == [{1..3, 1}, {1..3, 2}, {1..3, 3}]
    end

    test "works with many pages" do
      assert paginator(1..10, 7, &reflector/2) == [{1..10, 1}, {1..10, 6}, {1..10, 7}, {1..10, 8}, {1..10, 10}]
    end
  end

  describe "group_rounding_class/3" do
    test "handles the only element", do: assert group_rounding_class(1..1, 1) == "rounded-l rounded-r"
    test "handles the first element", do: assert group_rounding_class(1..2, 1) == "rounded-l"
    test "handles the last element", do: assert group_rounding_class(1..2, 2) == "rounded-r"
    test "handles middle elements", do: assert group_rounding_class(1..3, 2) == ""
    test "handles custom classes", do: assert group_rounding_class(1..3, 1, ["custom", "", ""]) == "custom"
  end

  describe "floating_form/3" do
    test "includes title and content" do
      markup =
        floating_form("Test Title", %{action: "test"}, do: "Test Content")
        |> safe_to_string()

      assert markup =~ "Test Title"
      assert markup =~ "Test Content"
    end
  end

  describe "floating_page_wrapper/1" do
    test "includes content" do
      markup =
        floating_page_wrapper(do: "Test Content")
        |> safe_to_string()

      assert markup =~ "Test Content"
    end
  end

  test "pow_extension_enabled?/1" do
    assert pow_extension_enabled?(PowEmailConfirmation) == true
    assert pow_extension_enabled?(:donkdonk) == false
  end
end
