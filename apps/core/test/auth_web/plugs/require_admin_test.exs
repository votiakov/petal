defmodule Legendary.AuthWeb.Plugs.RequireAdminTest do
  use Legendary.CoreWeb.ConnCase, async: true

  alias Legendary.AuthWeb.Plugs.RequireAdmin
  alias Legendary.Auth.User

  setup %{conn: conn} do
    %{conn: Pow.Plug.put_config(conn, current_user_assigns_key: :current_user)}
  end

  test "init/1" do
    assert RequireAdmin.init([]) == []
  end

  test "call/2 without user", %{conn: conn} do
    conn = RequireAdmin.call(conn, [])

    assert response(conn, 403)
    assert conn.halted
  end

  test "call/2 with a user", %{conn: conn} do
    conn =
      conn
      |> Pow.Plug.assign_current_user(%User{roles: ["admin"]}, [])
      |> RequireAdmin.call([])

    assert !conn.halted
  end

  test "call/2 with a user who is not admin", %{conn: conn} do
    conn =
      conn
      |> Pow.Plug.assign_current_user(%User{roles: []}, [])
      |> RequireAdmin.call([])

    assert conn.halted
  end
end
