defmodule Legendary.Auth.User do
  @moduledoc """
  The baseline user schema module.
  """
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  import Pow.Ecto.Schema.Changeset, only: [new_password_changeset: 3]

  alias Ecto.Changeset

  schema "users" do
    field :roles, {:array, :string}
    field :display_name, :string
    field :homepage_url, :string

    pow_user_fields()

    timestamps()
  end

  def admin_changeset(user_or_changeset, attrs) do
    role_list = Phoenix.json_library().decode!(Map.get(attrs, "roles"))
    attrs = Map.put(attrs, "roles", role_list)

    user_or_changeset
    |> pow_user_id_field_changeset(attrs)
    |> Changeset.cast(attrs, [:roles, :display_name])
    |> pow_extension_changeset(attrs)
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_user_id_field_changeset(attrs)
    |> pow_current_password_changeset(attrs)
    |> new_password_changeset(attrs, @pow_config)
    |> Changeset.cast(attrs, [:roles])
    |> pow_extension_changeset(attrs)
  end

  def reset_password_changeset(%Legendary.Auth.User{} = user, params) do
    user
    |> new_password_changeset(params, @pow_config)
    |> Changeset.validate_required([:password])
  end
end
