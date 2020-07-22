defmodule Content.MenusController do
  use Content, :controller

  alias Content.Repo

  def edit(conn, %{"id" => id}) do
    menu = id |> Content.Menu.get_menu_from_id()
    posts =
      Content.Posts.post_scope
      |> Repo.all()
      |> Enum.map(fn post ->
        post |> Map.take([:ID, :post_title, :post_name])
      end)
    categories =
      Content.Terms.categories
      |> Repo.all()
      |> Enum.map(fn cat ->
        cat |> Map.take([:name, :slug, :term_group, :term_id])
      end)

    conn
    |> render(
      "edit.html",
      [
        id: id,
        menu: menu,
        posts: posts,
        categories: categories,
      ]
    )
  end

  def update(conn, %{"id" => id, "menu" => menu}) do
    Content.UpdateMenu.run(id, menu |> Phoenix.json_library().decode!())

    conn
    |> redirect(to: Routes.menus_path(conn, :edit, id))
  end
end
