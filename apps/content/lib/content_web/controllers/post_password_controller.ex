defmodule Legendary.Content.PostPasswordController do
  use Legendary.Content, :controller

  def create(conn, %{"post_password" => post_password}) do
    conn = put_session(conn, "post_password", post_password)

    redirect_path =
      if Enum.count(get_req_header(conn, "referer")) > 0 do
        conn
        |> get_req_header("referer")
        |> Enum.at(0)
        |> URI.parse()
        |> (&(&1.path)).()
      else
        "/"
      end

    redirect conn, to: redirect_path
  end
end
