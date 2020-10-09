defmodule AuthWeb.Helpers do
  def has_role?(conn = %Plug.Conn{}, role) do
    conn
    |> Pow.Plug.current_user()
    |> Auth.Roles.has_role?(role)
  end
end
