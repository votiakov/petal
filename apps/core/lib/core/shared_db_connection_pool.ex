defmodule Core.SharedDBConnectionPool do
  @moduledoc """
  A shareable connection pool. We use this so that all the apps connecting to
  one database can use on connection pool, even if they have different repos.

  This allows a reasonable number of connections to be available per application
  without requiring a huge number of connections to the database.
  """
  alias DBConnection.ConnectionPool

  def start_link({mod, opts}) do
    case GenServer.start_link(ConnectionPool, {mod, opts}, Keyword.take(opts, [:name, :spawn_opt])) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      error -> error
    end
  end

  def child_spec({mod, opts}) do
    opts = Keyword.put_new(opts, :name, key(opts))
    Supervisor.Spec.worker(Core.SharedDBConnectionPool, [{mod, opts}])
  end

  defp key(opts) do
    key_hash =
      case opts do
        %{url: url} ->
          Ecto.Repo.Supervisor.parse_url(url)
        _ ->
          opts
      end
      |> hash_opts()

    String.to_atom("Core.SharedDBConnectionPool.#{key_hash}")
  end

  defp hash_opts(opts) do
    unhashed_key =
      opts
      |> Keyword.take([:hostname, :username, :password, :database])
      |> Keyword.values()
      |> Enum.join("/")

    :crypto.hash(:sha3_256, unhashed_key) |> Base.encode16()
  end
end