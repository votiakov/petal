defmodule Mix.Tasks.Legendary.CreateAdminTest do
  use Legendary.Core.DataCase

  import Mix.Tasks.Legendary.CreateAdmin

  alias Legendary.Auth.User

  describe "run/1" do
    test "creates an admin user" do
      run(["--email=test@example.com", "--password=openseasame"])

      user = from(u in User, where: u.email == "test@example.com") |> Repo.one()

      assert %User{email: "test@example.com"} = user
    end
  end
end
