defmodule AppWeb.LiveHelpers do
  @moduledoc """
  Commonly functions for LiveViews.
  """
  import Phoenix.LiveView

  def assign_defaults(socket, session) do
    assign_new(socket, :current_user, fn -> get_user(socket, session) end)
  end

  def require_auth(socket) do
    case socket.assigns do
      %{current_user: user} when not is_nil(user) ->
        socket
      _ ->
        redirect(socket, to: "/")
    end
  end

  defp get_user(socket, session, config \\ [otp_app: :core])

  defp get_user(socket, %{"core_auth" => signed_token}, config) do
    {otp_app, _config} = Keyword.pop(config, :otp_app, :core)
    {store, store_config} = Pow.Plug.Base.store(Application.get_env(otp_app, :pow))

    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
        {user, _metadata} <- store.get(store_config, token) do
      user
    else
      _any -> nil
    end
  end

  defp get_user(_, _, _), do: nil
end
