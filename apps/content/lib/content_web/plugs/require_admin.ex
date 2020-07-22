defmodule Content.RequireAdmin do
  @moduledoc """
  A plug that returns 403 unauthorized if the user is not an admin. Used
  to block out logged-in-only routes.
  """
  import Plug.Conn
  alias Auth.User

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if conn.assigns[:current_user] && User.is_admin?(conn.assigns[:current_user]) do
      conn
    else
      conn
      |> send_resp(403, "Unauthorized")
      |> halt()
    end
  end
end
