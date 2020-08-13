defmodule CoreEmailTest do
  use Core.DataCase

  import CoreEmail

  test "base_email/1" do
    assert %Bamboo.Email{} = base_email()
  end
end
