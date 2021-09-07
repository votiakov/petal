defmodule AppWeb.LiveHelpersText do
  use AppWeb.ConnCase

  import Mock

  import AppWeb.LiveHelpers

  describe "assign_defaults/2" do
    test "sets current_user" do
      {store, _store_config} = Pow.Plug.Base.store(Application.get_env(:core, :pow))
      socket = %Phoenix.LiveView.Socket{endpoint: AppWeb.Endpoint}

      with_mock Pow.Plug, [verify_token: fn (_, _, _, _) -> {:ok, "h3110"} end] do
        with_mock store, [get: fn (_config, _token) -> {%{id: 1234}, nil} end] do
          new_socket = assign_defaults(socket, %{"core_auth" => "h3ll0"})
          assert %{assigns: %{current_user: %{id: 1234}}} = new_socket
        end
      end
    end
  end

  describe "require_auth/1" do
    test "with user" do
      user = %{id: 4567}
      socket =
        %Phoenix.LiveView.Socket{assigns: %{current_user: user}}
        |> require_auth()

      assert !socket.redirected
    end

    test "without user" do
      socket = %Phoenix.LiveView.Socket{} |> require_auth()

      assert socket.redirected
    end

    test "without nil user" do
      socket =
        %Phoenix.LiveView.Socket{assigns: %{current_user: nil}}
        |> require_auth()

      assert socket.redirected
    end
  end
end
