defmodule Legendary.CoreWeb.Plug.TestEndToEnd do
  @moduledoc """
  Provides an API used by Cypress to remote control the database state for
  integration tests.
  """
  use Plug.Router

  plug :match
  plug :dispatch, builder_opts()

  post "/db/setup" do
    # If the agent is registered and alive, a db connection is checked out already
    # Otherwise, we spawn the agent and let it(!) check out the db connection
    owner_process = Process.whereis(:db_owner_agent)
    if owner_process && Process.alive?(owner_process) do
      send_resp(conn, 200, "connection has already been checked out")
    else
      {:ok, _pid} = Agent.start_link(&checkout_shared_db_conn/0, name: :db_owner_agent)
      case load_test_seeds(conn) do
        {:ok, _} ->
          send_resp(conn, 200, "connection checked out")
        {:error, msg} ->
          send_resp(conn, 500, msg)
      end
    end
  end

  post "/db/teardown" do
    # If the agent is registered and alive, we check the connection back in
    # Otherwise, no connection has been checked out, we ignore this
    owner_process = Process.whereis(:db_owner_agent)
    if owner_process && Process.alive?(owner_process) do
      Agent.get(owner_process, &checkin_shared_db_conn/1)
      Agent.stop(owner_process)
      send_resp(conn, 200, "checked in database connection")
    else
      send_resp(conn, 200, "connection has already been checked back in")
    end
  end

  match _, do: send_resp(conn, 404, "Not found")

  defp checkout_shared_db_conn do
    Ecto.Repo.all_running()
    |> Enum.map(fn repo ->
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(repo, ownership_timeout: :infinity)
      case Ecto.Adapters.SQL.Sandbox.mode(repo, {:shared, self()}) do
        :ok -> :ok
        :already_shared -> :ok
      end
    end)
  end

  defp checkin_shared_db_conn(_) do
    Ecto.Repo.all_running()
    |> Enum.map(fn repo ->
      :ok = Ecto.Adapters.SQL.Sandbox.checkin(repo)
    end)
  end

  @valid_seed_set_characters ~r{\A[A-Za-z\-_/]+\z}
  @valid_app_characters ~r{\A[a-z_]+\z}

  defp load_test_seeds(conn) do
    with {:ok, seed_set} <- Map.fetch(conn.body_params, "seed_set"),
         {:app, {:ok, app}} <- {:app, Map.fetch(conn.body_params, "app")},
         true <- String.match?(seed_set, @valid_seed_set_characters),
         true <- String.match?(app, @valid_app_characters) do

        project_base = Path.expand(Path.join(__DIR__, "../../../../.."))
        seed_path = Path.join(project_base, "apps/#{app}/test/seed_sets/#{seed_set}.exs")

        try do
          {result, _} = Code.eval_file(seed_path)
          {:ok, result}
        rescue
          e in Code.LoadError ->
            {:error, e.message}
        end
    else
      {:app, :error} -> {:error, "app parameter is required if seed set is set"}
      :error -> {:ok, nil} # seed_set param is missing
      false -> {:error, "invalid seed set name"}
    end
  end
end
