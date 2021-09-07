defmodule Legendary.AuthWeb.HelpersTest do
  use Legendary.CoreWeb.ConnCase, async: true

  import Legendary.AuthWeb.Helpers

  alias Phoenix.LiveView.Socket

  describe "current_user/1" do
    test "can get a user from the assigns in a socket", do: assert current_user(%Socket{assigns: %{current_user: %{id: 867}}}).id == 867
    test "can get a user from the __assigns__ in a socket", do: assert current_user(%Socket{assigns: %{__assigns__: %{current_user: %{id: 867}}}}).id == 867
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
end
