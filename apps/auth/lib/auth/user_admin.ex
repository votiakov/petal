defmodule Auth.UserAdmin do
  import Ecto.Query, only: [from: 2]
  alias Auth.{Repo,User}

  def widgets(_schema, _conn) do
    user_count =
      (from u in User,
        select: count(u.id))
      |> Repo.one()

    [
      %{
        icon: "users",
        type: "tidbit",
        title: "Registered Users",
        content: user_count,
        width: 3
      }
    ]
  end
end
