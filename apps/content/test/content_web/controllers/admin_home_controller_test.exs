defmodule Content.AdminHomeControllerTest do
  use Content.ConnCase

  alias Content

  describe "index" do
    test "loads ok", %{conn: conn} do
      conn =
        as_admin do
          get conn, Routes.admin_home_path(conn, :index)
        end
      assert html_response(conn, 200)
    end
  end
end
