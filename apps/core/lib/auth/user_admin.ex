defmodule Legendary.Auth.UserAdmin do
  import Ecto.Query, only: [from: 2]
  alias Legendary.Auth.User
  alias Legendary.Core.Repo

  def create_changeset(schema, attrs) do
    Legendary.Auth.User.admin_changeset(schema, attrs)
  end

  def update_changeset(schema, attrs) do
    Legendary.Auth.User.admin_changeset(schema, attrs)
  end

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

  def index(_) do
    [
      id: nil,
      email: nil,
      roles: %{value: fn u -> Enum.join(u.roles, ", ") end},
      display_name: nil,
      homepage_url: nil,
      email_confirmed_at: nil,
      inserted_at: nil,
      updated_at: nil,
    ]
  end

  def form_fields(_) do
    [
      email: nil,
      roles: nil,
      display_name: nil,
      homepage_url: nil,
    ]
  end
end
