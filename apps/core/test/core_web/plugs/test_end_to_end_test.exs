defmodule Legendary.CoreWeb.Plug.TestEndToEndTest do
  use Legendary.CoreWeb.ConnCase

  test "/db/setup can check out a connection", %{conn: conn} do
    conn = post conn, "/end-to-end/db/setup", %{seed_set: "test_end_to_end_test", app: "core"}

    assert response(conn, 200) =~ "connection checked out"
  end

  test "/db/setup twice is a no-op", %{conn: conn} do
    conn = post conn, "/end-to-end/db/setup", %{seed_set: "test_end_to_end_test", app: "core"}
    conn = post conn, "/end-to-end/db/setup", %{seed_set: "test_end_to_end_test", app: "core"}

    assert response(conn, 200) =~ "connection has already been checked out"
  end

  test "/db/setup with no-existent seed set is an error", %{conn: conn} do
    conn = post conn, "/end-to-end/db/setup", %{seed_set: "oops", app: "core"}

    assert response(conn, 500) =~ "could not load"
    assert response(conn, 500) =~ "oops.exs"
  end

  test "/db/teardown can check in a connection", %{conn: conn} do
    conn = post conn, "/end-to-end/db/setup", %{seed_set: "test_end_to_end_test", app: "core"}
    conn = post conn, "/end-to-end/db/teardown"

    assert response(conn, 200) =~ "checked in database connection"
  end

  test "/db/teardown checking in twice is a no-op", %{conn: conn} do
    conn = post conn, "/end-to-end/db/setup", %{seed_set: "test_end_to_end_test", app: "core"}
    conn = post conn, "/end-to-end/db/teardown"
    conn = post conn, "/end-to-end/db/teardown"

    assert response(conn, 200) =~ "connection has already been checked back in"
  end
end
