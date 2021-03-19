defmodule Legendary.AuthWeb.HelpersTest do
  use Legendary.CoreWeb.ConnCase

  import Legendary.AuthWeb.Helpers

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
