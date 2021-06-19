defmodule AuthWeb.Pow.ControllerCallbacks do
  @moduledoc """
  Hook into Pow Controllers to provide additional framework feature. In particular,
  we disconnect any active live views when a user logs out. This will cause the
  live view to re-connect with the new session environment.
  """
  alias Pow.Extension.Phoenix.ControllerCallbacks
  alias Plug.Conn

  def before_respond(Pow.Phoenix.SessionController, :create, {:ok, conn}, config) do
    user = conn.assigns.current_user

    conn =
      conn
      |> Conn.put_session(:current_user_id, user.id)
      |> Conn.put_session(:live_socket_id, "users_sockets:#{user.id}")

    ControllerCallbacks.before_respond(
      Pow.Phoenix.SessionController,
      :create,
      {:ok, conn},
      config
    )
  end

  def before_respond(Pow.Phoenix.SessionController, :delete, {:ok, conn}, config) do
    live_socket_id = Conn.get_session(conn, :live_socket_id)
    AppWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})

    conn =
      conn
      |> Conn.delete_session(:live_socket_id)

    ControllerCallbacks.before_respond(
      Pow.Phoenix.SessionController,
      :delete,
      {:ok, conn},
      config
    )
  end

  defdelegate before_respond(controller, action, results, config), to: ControllerCallbacks

  defdelegate before_process(controller, action, results, config), to: ControllerCallbacks
end
