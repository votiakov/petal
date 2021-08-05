defmodule Legendary.AuthWeb.Helpers do
  @moduledoc """
  Utility functions for working with users and roles.
  """

  def current_user(%Phoenix.LiveView.Socket{assigns: %{current_user: user}}), do: user
  def current_user(%Phoenix.LiveView.Socket{assigns: %{__assigns__: %{current_user: user}}}), do: user
  def current_user(%Phoenix.LiveView.Socket{}), do: nil
  def current_user(conn), do: Pow.Plug.current_user(conn)

  def has_role?(conn_or_socket, role) do
    conn_or_socket
    |> current_user()
    |> Legendary.Auth.Roles.has_role?(role)
  end
end
