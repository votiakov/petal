defmodule LegendaryWeb.PageController do
  use LegendaryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
