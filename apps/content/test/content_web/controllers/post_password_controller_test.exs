defmodule Legendary.Content.PostPasswordControllerTest do
  use Legendary.Content.ConnCase
  use Plug.Test

  import Plug.Conn

  describe "create" do
    test "accepts post_password and puts in session (with referer)", %{conn: conn} do
      conn = conn |> put_req_header("referer", "https://example.com/test")
      conn = post conn, Routes.post_password_path(conn, :create), %{"post_password" => "testpass"}

      assert conn |> get_session("post_password") == "testpass"
    end

    test "accepts post_password and puts in session (without referer)", %{conn: conn} do
      conn = post conn, Routes.post_password_path(conn, :create), %{"post_password" => "testpass"}

      assert conn |> get_session("post_password") == "testpass"
    end
  end
end
