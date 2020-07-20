defmodule ContentWeb.PageControllerTest do
  use ContentWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/index")
    assert html_response(conn, 200)
  end
end
