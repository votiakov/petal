defmodule Legendary.AuthWeb.Pow.ControllerCallbacksTest do
  use Legendary.CoreWeb.ConnCase, async: true

  import Legendary.AuthWeb.Pow.ControllerCallbacks
  import Plug.Conn, only: [assign: 3, get_session: 2]

  alias Legendary.Auth.User

  describe "before_respond/4" do
    setup %{conn: conn} do
      conn =
        conn
        |> init_test_session([])
        |> assign(:current_user, %User{id: 123})

      %{conn: conn}
    end

    test "sets the live_socket_id in session upon sign in", %{conn: conn} do
      {:ok, conn} = before_respond(Pow.Phoenix.SessionController, :create, {:ok, conn}, [])

      assert get_session(conn, "live_socket_id") == "users_sockets:123"
      assert get_session(conn, "current_user_id") == 123
    end

    test "removes the live_socket_id and broadcasts a disconnect signal upon sign out", %{conn: conn, } do
      {:ok, conn} = before_respond(Pow.Phoenix.SessionController, :delete, {:ok, conn}, [])

      assert get_session(conn, "live_socket_id") == nil
      assert get_session(conn, "current_user_id") == nil
    end
  end
end
