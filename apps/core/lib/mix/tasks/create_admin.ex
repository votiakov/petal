defmodule Mix.Tasks.Legendary.CreateAdmin do
  @moduledoc """
  Mix task to create an admin user from the command line.
  """
  use Mix.Task

  alias Legendary.Auth.User
  alias Legendary.Core.Repo
  alias Ecto.Changeset

  @shortdoc "Create an admin user."
  def run(args) do
    Application.ensure_all_started(:core)

    {switches, _, _} = OptionParser.parse(args, strict: [email: :string, password: :string])

    email = Keyword.get_lazy(switches, :email, fn -> ExPrompt.string_required("Email: ") end)
    password = Keyword.get_lazy(switches, :password, fn -> ExPrompt.password("Password: ") end)

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

  defp maybe_confirm_email(changeset) do
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
