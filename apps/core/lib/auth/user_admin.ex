defmodule Legendary.Auth.UserAdmin do
  @moduledoc """
  Custom admin login for user records.
  """
  import Ecto.Query, only: [from: 2]
  alias Legendary.Auth.User
  alias Legendary.Core.Repo

  def custom_links(_schema) do
    # We add the funwithflags admin URL under this custom admin because kaffy
    #   doesn't have global custom links that work in this way and user is the
    #   closest fit.
    [
      %{name: "Feature Flags", url: "/admin/feature-flags", order: 2, location: :top, icon: "flag"},
    ]
  end

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
