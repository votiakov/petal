defmodule Content.RequireAuth do
  @moduledoc """
  A plug that returns 403 unauthorized if the user is not authenticated. Used
  to block out logged-in-only routes.
  """
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> send_resp(403, "Unauthorized")
        |> halt()
      _user ->
        conn
    end
  end
end
