defmodule Auth.UserTest do
  use Core.DataCase

  import Auth.User

  alias Auth.User

  describe "admin_changeset/2" do
    test "handles roles from text properly" do
      changeset = admin_changeset(%User{}, %{"roles" => ~S(["snorlax", "pikachu"])})

      assert changeset.changes.roles == ["snorlax", "pikachu"]
    end
  end

  describe "changeset/2" do
    test "requires an email" do
      changeset = changeset(%User{}, %{"password" => "bloopers"})

      refute changeset.valid?
    end

    test "does not require password confirmation" do
      changeset = changeset(%User{}, %{"email" => "bloop@example.org", "password" => "bloopers"})

      assert changeset.valid?
    end
  end

  describe "reset_password_changeset/2" do
    test "does not require password confirmation" do
      changeset = reset_password_changeset(%User{}, %{"password" => "bloopers"})

      assert changeset.valid?
    end
  end
end
