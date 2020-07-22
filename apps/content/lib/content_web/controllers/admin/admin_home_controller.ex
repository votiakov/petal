defmodule Content.AdminHomeController do
  use Content, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
