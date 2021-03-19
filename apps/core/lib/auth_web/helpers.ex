defmodule Legendary.AuthWeb.Helpers do
  def has_role?(conn = %Plug.Conn{}, role) do
    conn
    |> Pow.Plug.current_user()
    |> Legendary.Auth.Roles.has_role?(role)
  end
end
