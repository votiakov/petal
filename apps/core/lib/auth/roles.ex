defmodule Legendary.Auth.Roles do
  @moduledoc """
  Functions for working with roles on users, such as testing whether a user has
  a role.
  """

  def has_role?(userlike, role) when is_atom(role), do: has_role?(userlike, Atom.to_string(role))
  def has_role?(nil, _), do: false
  def has_role?(%Legendary.Auth.User{} = user, role) do
    Enum.any?(user.roles || [], & &1 == role)
  end
end
