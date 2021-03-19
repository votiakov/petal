defmodule Legendary.AuthWeb.Plugs.RequireAdmin do
  @moduledoc """
  A plug that returns 403 unauthorized if the user is not an admin. Used
  to block out logged-in-only routes.
  """
  import Plug.Conn
  alias Legendary.Auth.{Roles, User}

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with user = %User{} <- Pow.Plug.current_user(conn),
         true <- Roles.has_role?(user, "admin")
    do
      conn
    else
      _ ->
        conn
        |> send_resp(403, "Unauthorized")
        |> halt()
    end
  end
end
