defmodule Mix.Tasks.Legendary.CreateAdmin do
  @moduledoc """
  Mix task to create an admin user from the command line.
  """
  use Mix.Task

  alias Auth.User
  alias Core.Repo
  alias Ecto.Changeset

  @shortdoc "Create an admin user."
  def run(_) do
    Application.ensure_all_started(:core)

    email = ExPrompt.string_required("Email: ")
    password = ExPrompt.password("Password: ")

   params = %{
      email: email,
      password: password,
      roles: ["admin"],
    }

    %User{}
    |> User.changeset(params)
    |> maybe_confirm_email()
    |> Repo.insert!()
  end

  def maybe_confirm_email(changeset) do
    field_list = User.__schema__(:fields)

    case  Enum.any?(field_list, &(&1 == :email_confirmed_at)) do
      true ->
        changeset
        |> Changeset.cast(%{email_confirmed_at: DateTime.utc_now()}, [:email_confirmed_at])
      false ->
        changeset
    end
  end
end
