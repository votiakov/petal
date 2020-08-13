defmodule Auth.RolesTest do
  use Auth.DataCase

  import Auth.Roles

  alias Auth.User

  describe "has_role?/2" do
    test "with no user" do
      refute has_role?(nil, "admin")
    end

    test "with an atom role" do
      assert has_role?(%User{roles: ["admin"]}, :admin)
      refute has_role?(%User{roles: ["admin"]}, :blooper)
    end

    test "with a string role" do
      assert has_role?(%User{roles: ["admin"]}, "admin")
      refute has_role?(%User{roles: ["admin"]}, "blooper")
    end
  end
end
