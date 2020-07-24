defmodule Auth.Roles do
  def has_role?(userlike, role) when is_atom(role), do: has_role?(userlike, Atom.to_string(role))
  def has_role?(nil, _), do: false
  def has_role?(user = %Auth.User{}, role) do
    Enum.any?(user.roles, & &1 == role)
  end

  def has_role?(conn = %Plug.Conn{}, role) do
    conn
    |> Pow.Plug.current_user()
    |> has_role?(role)
  end
end
