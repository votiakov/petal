defmodule Content.PageControllerTest do
  use Content.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/index")
    assert html_response(conn, 200)
  end
end
