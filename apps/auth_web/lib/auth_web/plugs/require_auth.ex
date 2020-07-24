defmodule AuthWeb.Plugs.RequireAuth do
  @moduledoc """
  A plug that returns 403 unauthorized if the user is not authenticated. Used
  to block out logged-in-only routes.
  """
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if Pow.Plug.current_user(conn) do
      conn
    else
      conn
      |> send_resp(403, "Unauthorized")
      |> halt()
    end
  end
end
